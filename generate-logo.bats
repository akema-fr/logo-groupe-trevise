#!/usr/bin/env bats

setup() {
  export NO_ERROR=0
  export TEST_DIR=/tmp/test
  mkdir $TEST_DIR
  cp ./generate-logo.bash $TEST_DIR
  cd $TEST_DIR
  source ./generate-logo.bash
}

teardown() {
    rm --force --recursive $TEST_DIR
    unset TEST_DIR
}

@test "create directory if missing" {
  run create_png_dir

  [[ $status == "$NO_ERROR" ]]
  [[ -d $TEST_DIR/png ]]
}

@test "skip if directory exists" {
  DIR_ALREADY_EXISTS=1
  mkdir $TEST_DIR/png
  run create_png_dir

  [[ $status == "$DIR_ALREADY_EXISTS" ]]
  [[ -d $TEST_DIR/png ]]
}

@test "get path to PNG filepath from SVG filename" {
  run path_to_png "logo-trevise.horizontal.svg" 32

  [[ $status == "$NO_ERROR" ]]
  [[ $output == "png/logo-trevise.horizontal.32.png" ]]
}

@test "should export vertical version" {
  svg=file.vertical.svg
  echo "<svg viewBox='0 0 5 5' height='5' width='5'><g/></svg>" > $TEST_DIR/$svg
  png="$(path_to_png "$svg" 32)"

  create_png_dir
  run export_to_png "$svg" "$png" 32

  [[ $status == "$NO_ERROR" ]]
  [[ -f $TEST_DIR/$png ]]
  [[ $(identify -format '%h' "$png") == 32 ]]
}

@test "should export horizontal version" {
  create_png_dir
  svg=file.horizontal.svg
  echo "<svg viewBox='0 0 5 5' height='5' width='5'><g/></svg>" > $TEST_DIR/$svg
  png="$(path_to_png "$svg" 32)"

  run export_to_png "$svg" "$png" 32

  [[ $status == "$NO_ERROR" ]]
  [[ -f $TEST_DIR/$png ]]
  [[ $(identify -format '%w' "$png") == 32 ]]
}

@test "get path to monochrome PNG filepath from SVG filename" {
  png="png/logo-trevise.horizontal.png"
  run path_to_monochrome "$png" 32

  echo $output
  [[ $status == "$NO_ERROR" ]]
  [[ $output == "png/logo-trevise.bw-horizontal.32.png" ]]
}

@test "should create a monochrome version" {
  create_png_dir
  echo "<svg viewBox='0 0 5 5' height='5' width='5'><g/></svg>" > $TEST_DIR/file.svg
  png="$(path_to_png "file.svg" 32)"
  export_to_png "file.svg" "$png" 32

  monochrome=$(path_to_monochrome "$png" "$monochrome")
  run create_monochrome "$png" "$monochrome"

  [[ $status == "$NO_ERROR" ]]
  [[ -f $TEST_DIR/$monochrome ]]
}
