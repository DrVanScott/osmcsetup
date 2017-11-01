#there are additional commands after the patch!
sudo tee -a /etc/modules << PATCH

+snd_bcm2835
PATCH
sudo modprobe snd_bcm2835
