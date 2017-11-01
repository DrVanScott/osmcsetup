#!/bin/bash

KIDSPATH=/mnt/kids
KIDSPROFILE=Kinder
XBMC=/home/osmc/.kodi

MAGICFILE="_this_is_the_kids_folder_"
DBNAME=$(basename $(ls -1t $XBMC/userdata/Database/MyVideos*.db | head -1))
DATABASE="$XBMC/userdata/profiles/$KIDSPROFILE/Database/$DBNAME"
TMPDB="/tmp/$DBNAME"
TMPFILE="/tmp/$$xbmcKids.tmp"

cd "$KIDSPATH" || exit 1;
[ ! -f "$MAGICFILE" ] && { echo "no magic file $MAGICFILE in folder $KIDSPATH" 1>&2; exit 1; } || rm -f *
touch "$MAGICFILE"

cp "$XBMC"/userdata/Database/"$DBNAME" $TMPDB
sqlite3 $TMPDB "delete from files where idFile in (select idFile from movie where c14 not like '%Familie%');"
sqlite3 $TMPDB "delete from movie where c14 not like '%Familie%';" && \
sqlite3 $TMPDB "delete from tvshow;" && \
sqlite3 $TMPDB "delete from episode;" && \
mv $TMPDB "$DATABASE"

sqlite3 "$DATABASE" "select strPath, strFilename from files f, path p, movie m where m.idFile = f.idFile and f.idPath = p.idPath" > "$TMPFILE"

IFS="|" 
while read path name
do
  ln -s "$path$name" "$name"
done < "$TMPFILE"
rm "$TMPFILE"

NEWPATH=$(sqlite3 "$DATABASE" "select idPath from path where strPath = '"$KIDSPATH"/' and strContent='movies'")
NEWPATH=$(sqlite3 "$DATABASE" "select idPath from path where strPath = '"$KIDSPATH"/'")
[ "$?" -ne 0 -o -z "$NEWPATH" ] && { echo "no path for $KIDSPATH/ found in xbmc." 1>&2; exit 1; }

sqlite3 "$DATABASE" "update files set idPath='$NEWPATH' where idFile in (select idFile from movie)"
rsync -a $XBMC/userdata/Thumbnails $XBMC/userdata/profiles/Kinder
