sudo systemctl stop mediacenter
mkdir -p .kodi
tar -xzf /var/tmp/childprotect.tar -C .kodi
rm -f /var/tmp/childprotect.tar
ln -s .kodi/addons/script.service.autologout/waitForMaster.sh .
sudo systemctl start mediacenter
