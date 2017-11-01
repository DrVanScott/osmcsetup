#!/bin/bash

set -o nounset
set -o errexit

HOST=osmc
#HOST=raspbmc
USER=osmc

SSHOPT="PasswordAuthentication no"

function cleanup {

 [ ! -z "${TMPDIR:-}" ] && {
	[ -d "$TMPDIR" ] && {
		[ ! -z "${KEYFILE:-}" ] && {
			KEY=$(awk '{print $2}' "$KEYFILE".pub)
			ESCAPEDKEY=$(echo "$KEY" | sed -e 's/[]\/()$*.^|[]/\\&/g' )
			ssh -o "$SSHOPT" -i "$KEYFILE" $USER@$HOST sed '/'"'"$ESCAPEDKEY"'"'/d' -i .ssh/authorized_keys 2>/dev/null || true
		}
		rm -r "$TMPDIR"
	}
 }
}

function run_remote {
	file="$1"
	remotefile=$(basename "$file")

	cat "$file" | ssh -t -o "$SSHOPT" -i "$KEYFILE" $USER@$HOST 'cat - > /var/tmp/'"$remotefile"'$$; chmod u+x /var/tmp/'"$remotefile"'$$; source /etc/profile; bash -x /var/tmp/'"$remotefile"'$$; RET=$?; rm /var/tmp/'"$remotefile"'$$; exit $RET'
}


trap "cleanup; exit" INT TERM EXIT

echo creating temporary key pair
TMPDIR=$(mktemp -d /tmp/pi_setup.XXXXXXXX)
chmod 0700 "$TMPDIR"

KEYFILE="$TMPDIR"/rsa

ssh-keygen -t rsa -f "$KEYFILE" -N "" > /dev/null
echo Using ssh to copy public key to $USER@$HOST
ssh-copy-id -i "$KEYFILE".pub $USER@$HOST > /dev/null


echo installing base packages...
ssh -t -o "$SSHOPT" -i "$KEYFILE" $USER@$HOST "source /etc/profile; sudo apt-get -y update && sudo apt-get -y install $(cat packages)"

echo runing post package commands
run_remote modules.cmd
run_remote fstab.cmd
run_remote mpd.conf.patch.cmd
run_remote nginx.cmd
run_remote network.cmd


#preprocessing userdata dir
tar -czf "$TMPDIR"/kodi.tar -C kodi .
scp -o "$SSHOPT" -i "$KEYFILE" "$TMPDIR"/kodi.tar $USER@$HOST:/var/tmp/
run_remote kodi_config.cmd

#preprocessing childprotect
tar -czf "$TMPDIR"/childprotect.tar -C childprotect/.kodi .
scp -o "$SSHOPT" -i "$KEYFILE" "$TMPDIR"/childprotect.tar $USER@$HOST:/var/tmp/
run_remote childprotect.cmd

#preprocessing glocke ;-)
tar -czf "$TMPDIR"/Glocke.tar -C Glocke .
scp -o "$SSHOPT" -i "$KEYFILE" "$TMPDIR"/Glocke.tar $USER@$HOST:/var/tmp/
run_remote glocke.cmd
