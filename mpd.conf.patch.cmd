#there are additional commands after the patch!
sudo apt-get -y install mpd
sudo patch /etc/mpd.conf << PATCH
--- /etc/mpd.conf	2012-05-29 15:52:36.000000000 +0200
+++ mpd.conf	2013-07-04 23:06:16.745947422 +0200
@@ -10,14 +10,14 @@
 # be disabled and audio files will only be accepted over ipc socket (using
 # file:// protocol) or streaming files over an accepted protocol.
 #
-music_directory		"/var/lib/mpd/music"
+music_directory		"/mnt/Music"
 #
 # This setting sets the MPD internal playlist directory. The purpose of this
 # directory is storage for playlists created by MPD. The server will use 
 # playlist files not created by the server but only if they are in the MPD
 # format. This setting defaults to playlist saving being disabled.
 #
-playlist_directory		"/var/lib/mpd/playlists"
+playlist_directory		"/mnt/Music/playlists"
 #
 # This setting sets the location of the MPD database. This file is used to
 # load the database at server start up and store the database while the 
@@ -79,7 +79,7 @@
 # to have mpd listen on every address
 #
 # For network
-bind_to_address		"localhost"
+bind_to_address		"0.0.0.0"
 #
 # And for Unix Socket
 #bind_to_address		"/var/run/mpd/socket"
@@ -195,12 +195,16 @@
 # See <http://mpd.wikia.com/wiki/Configuration#Audio_Outputs> for examples of 
 # other audio outputs.
 #
+#audio_output {
+#    type    "pulse"
+#    name    "Wohnzimmer"
+#}
 # An example of an ALSA output:
 #
 audio_output {
-	type		"alsa"
-	name		"My ALSA Device"
-	device		"hw:0,0"	# optional
+    type    "alsa"
+    name    "Wohnzimmer"
+    device  "hw:0,0"    # optional
 	format		"44100:16:2"	# optional
 	mixer_device	"default"	# optional
 	mixer_control	"PCM"		# optional
@@ -341,7 +345,7 @@
 # the argument "album" or "track". See <http://www.replaygain.org> for more
 # details. This setting is disabled by default.
 #
-#replaygain			"album"
+replaygain			"track"
 #
 # This setting sets the pre-amp used for files that have ReplayGain tags. By
 # default this setting is disabled.
PATCH
sudo service mpd restart
sleep 4
echo "update" | nc localhost 6600
