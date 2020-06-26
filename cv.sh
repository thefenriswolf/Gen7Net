#!/bin/bash

src=$2
dest=$3

function cv_help() {
  echo -e "
                _     
               | |    
  _____   _____| |__  
 / __\ \ / / __| '_ \ 
| (__ \ V /\__ \ | | |
 \___| \_(_)___/_| |_|
                      
		      "
  echo -e "cv.sh depends on the following utilities:\n \t rsync \n \t imagemagick \n \t detox \n \t find"
  echo -e "cv.sh can extract .jpg files from .dcm files using imagemagick."
  echo -e "It can also 'clean' your working directory by removing all created .jpg files \nand removes spaces from folder and filenames using the 'detox' utility!"
  echo -e "Once all files are converted cv.sh will rename them accourding to the folder structure they are in."
  echo -e "cv.sh can also extract the converted .jpg files from the curret working directory\nto another given folder using 'rsync'.\n"
  echo -e "Usage:\n \t cv.sh [command] [/path/to/source/] [/path/to/destination/]\n"
  echo -e "Available Commands:\n"
  echo -e "\t help\t\tDisplay this help message.\n \t convert\tConvert all .dcm files in the source directory to .jpg files and rename them."
  echo -e "\t clean\t\tRemove ALL! .jpg files from the source directory.\n\t transfer\tcopy all .jpg files from the src dir to the destination preseving\n\t\t\tall folder structure of the src dir.\n"
}

function cv_convert() {
  detox -vr -s utf_8 $src # remove spaces from filenames and folders
  counter=0
  for i in $(find $src -depth -type f -name *.dcm) # find all files of a specific type
    do
	    # use imagemagick to convert from .dcm to .jpg; pass -auto-level otherwise the images turn out too dark
	    convert -auto-level $i ${i//.dcm/.jpg}
	    counter=$((counter + 1))
	    echo -e -n 'working ... \r'
    done
# rename all .jpg after the dir they are in; imagemagick complains about the target dir if I try to wrap it in there
  for f in $src/*/*/*/*.jpg
    do 
       fp=$(dirname "$f")
       fl=$(basename "$f")
       fnp=${fp//['/']/'_'}
       mv $f $fp/$fnp-$fl 
    done 
# finish performance monitoring
  echo "converted" $counter "files"
}

function cv_clean() {
  start=$SECONDS
  counter=0
  for i in $(find $src -depth -type f -name *.jpg)
    do
	    rm $i
	    counter=$((counter + 1))
    	echo -e -n 'cleaning working directory ... \r'
    done
  end=$SECONDS
  echo "cleaned" $counter "files in $((end-start)) seconds"
}

function cv_transfer() {
# use rsync to extract all .jpg from working directory to a safe backup location
  rsync --exclude=*.dcm --exclude=*.sh --exclude=*.nix --exclude=*.py --exclude=.envrc --exclude=*.git --stats -rhz $src $dest
}

case $1 in

  help | h)
    cv_help
    ;;
  convert | cv)
    cv_convert
    ;;
  clean | clear | clr)
    cv_clean
    ;;
  transfer | copy | extract)
    cv_transfer
    ;;
  *)
    cv_help
    ;;
esac
