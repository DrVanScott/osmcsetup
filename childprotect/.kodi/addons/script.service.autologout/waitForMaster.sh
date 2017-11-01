#!/bin/bash

SENTINAL="/tmp/.heyYouLetMeIn"

[[ -f "$SENTINAL" ]] && { echo "Sentinel-Datei existiert bereits. Kaputt?"; exit 1; }

touch "$SENTINAL"

while ([[ -e "$SENTINAL" ]])
do
    sleep .1
done

echo "Master sollte nun aktiv sein"
