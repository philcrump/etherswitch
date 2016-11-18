#!/bin/bash

# deploy.sh <image file> <folder>
if [ ! -f "$1" ]
then
  echo "deploy.sh <image file> <folder>"
  echo "  Availible images:"
  IFS=$'\n'
  for imagefile in `ls -1 -t | grep '.bin'`
  do
    echo $imagefile
  done
  unset IFS
  exit 1
fi

image_file=$1
gitref="`basename "$image_file" .bin`"
checksum_file="$gitref.md5"

if [ ! -d "$2" ]
then
  echo "deploy.sh <image file> <folder>"
  echo "  Availible folders:"
  ls /srv/netswitch/fw/
  exit 1
fi

target_dir=$2

echo "Checksumming image"
md5sum $image_file > $checksum_file

echo "Copying files"
cp -v $image_file $target_dir/
cp -v $checksum_file $target_dir/

if [ ! -f "$target_dir/versions.txt" ]
then
  touch "$target_dir/versions.txt"
fi

echo "Type a release comment, followed by [ENTER]:"
read image_comment

timestamp=$(date +"%Y-%m-%d-%H%M")
echo -e "$timestamp - $gitref\n - $image_comment\n\n$(cat $target_dir/versions.txt)" >> $target_dir/versions.txt

echo "Updating latest ref"
echo "$gitref" > $target_dir/latest

echo "Done."
