#!/usr/bin/env bash

[[ ! -d png ]] && mkdir png/

for svg in logo-trevise.*.svg; do
  echo $svg $png
  sizes=( 64 128 256 512 1024 )
  for size in "${sizes[@]}"; do
    png="png/${svg//.svg/.$size.png}"
    [[ $png =~ vertical ]] && inkscape --without-gui --export-height=$size --export-png="$png" --file="$svg"
    [[ $png =~ horizontal ]] && inkscape --without-gui --export-width=$size --export-png="$png" --file="$svg"
  done
done
