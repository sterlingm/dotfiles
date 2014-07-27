#!/bin/bash

COLEMAK=$(setxkbmap -print | grep colemak)
NORMAN=$(setxkbmap -print | grep norman)

if [[ -n $COLEMAK ]] 
then
  exit 2
elif [[ -n $NORMAN ]]
then
  exit 1
else
  exit 0
fi
