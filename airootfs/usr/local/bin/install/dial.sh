#!/bin/bash


DISKCONF=$(yad --title="Instalation GUI" --text="disk configuration" --form \
    --field="Where to store boot:MDIR" \
    --field="Where to store root:" \
    --field="Where to store data:" \
    --button="OK:0" \
    --button="Cancel:1")

EXIT_CODE=$?

USERCONF=$(yad --title="instalation GUI" --text="user configuration" --form \
    --field="username:" \
    --field="user password:H" \
    --field="time zone:")

if [ $EXIT_CODE -eq 0 ]; then
    BOOT=$(echo "$DISKCONF" | awk -F'|' '{print $1}')
    ROOT=$(echo "$DISKCONF" | awk -F'|' '{print $2}')
    DATA=$(echo "$DISKCONF" | awk -F'|' '{print $3}')
    USER=$(echo "$USERCONF" | awk -F'|' '{print $1}')
    PSWD=$(echo "$USERCONF" | awk -F'|' '{print $2}')
    TIME=$(echo "$USERCONF" | awk -F'|' '{print $3}')
    
    echo "boot: " $BOOT
    echo "root: " $ROOT
    echo "data: " $DATA
    echo "username: " $USER
    echo "password: " $PSWD
    echo "timezone: " $TIME
else
    echo "Instalation cancelled."
  fi