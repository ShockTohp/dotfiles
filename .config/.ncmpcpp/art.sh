#!/bin/bash

#put this file to ~/.ncmpcpp/




MUSIC_DIR=~/mnt/media/Music #path to your music dir

COVER=/tmp/cover.png

function reset_background
{
    printf "\e]20;;100x100+1000+1000\a"
}

{
    album="$(mpc -p 6600 --format %album% current)"
    file="$(mpc -p 6600 --format %file% current)"
    title="$(mpc -p 6600 --format %title% current)"
    artist="$(mpc -p 6600 --format %artist% current)" 
    album_dir="${file%/*}"
    [[ -z "$album_dir" ]] && exit 1
    album_dir="$MUSIC_DIR/$album_dir"
    newline="\n"

    covers="$(find "$album_dir" -type d -exec find {} -maxdepth 1 -type f -iregex ".*/.*\(${album}\|cover\|folder\|artwork\|front\).*[.]\(jpe?g\|png\|gif\|bmp\)" \; )"
    src="$(echo -n "$covers" | head -n1)"
    rm -f "$COVER"
    if [[ -n "$src" ]] ; then
        #resize the image's width to 300px
        convert "$src" -resize 300x "$COVER"
        if [[ -f "$COVER" ]] ; then
           #scale down the cover to 30% of the original
           #printf "\e]20;${COVER};30x70+0+00:op=keep-aspect\a"
	   dunstify --raw_icon=${COVER} "$title -- $artist"
        else
            reset_background
        fi
    else
        reset_background
    fi
} &
