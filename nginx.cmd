sudo apt-get -y install nginx
sudo tee /etc/nginx/sites-available/mpd-cover.conf > /dev/null << 'FILE'
server {
    listen 4711;
    server_name raspbmc;

    location /cover-art/ {
        root /mnt/Music/;
        rewrite /cover-art/(.*) /$1 break;
        try_files $uri $uri;
        allow   all;
        deny    all;
    }
}
FILE
sudo ln -fs /etc/nginx/sites-available/mpd-cover.conf /etc/nginx/sites-enabled
sudo rm -f /etc/nginx/sites-enabled/default
sudo service nginx restart
