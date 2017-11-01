#there are additional commands after the patch!
sudo mkdir -p /mnt/Music
sudo mkdir -p /mnt/Video
sudo apt-get -y install cifs-utils
sudo tee -a /etc/fstab << PATCH

//fritz.nas/fritz.nas/Hitachi-HDS5C1010CLA382-01/Music  /mnt/Music  cifs  auto,guest,user=osmc,iocharset=utf8,nomapchars,nomapposix  0  0
//fritz.nas/fritz.nas/Hitachi-HDS5C1010CLA382-01/Video  /mnt/Video  cifs  auto,guest,user=osmc,iocharset=utf8,nomapchars,nomapposix  0  0

PATCH
sudo mount -a
