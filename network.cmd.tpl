exit 0
#replace MyWifi with real name
sudo touch /etc/NetworkManager/system-connections/MyWifi
sudo chmod go-rwx /etc/NetworkManager/system-connections/MyWifi
sudo tee /etc/NetworkManager/system-connections/MyWifi > /dev/null << FILE
[connection]
id=MyWifi
uuid=MyWifi_uuid
type=802-11-wireless

[802-11-wireless]
ssid=MyWifi
mode=infrastructure
mac-address=MyWifi_mac
security=802-11-wireless-security

[802-11-wireless-security]
key-mgmt=wpa-psk
auth-alg=open
psk=MyWifi_psk

[ipv4]
method=auto

[ipv6]
method=auto
FILE
sudo service network-manager restart
