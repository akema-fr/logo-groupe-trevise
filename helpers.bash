#!/usr/bin/env bash

function create_png_dir() {
    [[ ! -d png ]] && mkdir png/
}

function path_to_png() {
    local svg="$1"
    local size="$2"

    png="png/${svg//.svg/.$size.png}"
    echo $png
}

function export_to_png() {
    local svg="$1"
    local png="$2"
    local size="$3"

    [[ $png =~ vertical ]] && dimension=--export-height=$size
    [[ $png =~ horizontal ]] && dimension=--export-width=$size

    inkscape --without-gui $dimension --export-png="$png" --file="$svg"
}

function path_to_monochrome() {
    local png="$1"

    monochrome="${png/./.bw-}"
    echo $monochrome
}

function create_monochrome() {
    convert "$png" -colorspace Gray "$monochrome"
}

function generate-logo() {
    create_png_dir
    for svg in logo-trevise.*.svg; do
        sizes=( 64 128 256 512 1024 )
        for size in "${sizes[@]}"; do
            png=$(path_to_png "$svg" "$size")
            export_to_png "$svg" "$png" $size

            monochrome="$(path_to_monochrome "$png" "$size")"
            create_monochrome "$png" "$monochrome"
        done
    done
}
