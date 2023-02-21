#!/bin/bash

TEMP='temp'
function yda() { youtube-dl -x --audio-format mp3 --output "$TEMP.%(ext)s"  $1 ;}
#1 start time 00:00:00 #2 duration 00:00:00 #3 input file name #4 output file name
function cut() {
    ffmpeg -ss $1 -t $2 -i $TEMP.mp3 $3.mp3
    rm $TEMP.mp3
}

#1 url #2 start time #3 duration #4 destination
yda $1
cut $2 $3 $4
say "$4下载完毕"
