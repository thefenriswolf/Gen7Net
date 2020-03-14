#!/bin/bash

dir=$1 # store arg1
dest=$2 # store arg2
start=$SECONDS # performance monitoring
detox -nvr -s utf_8 $dir # remove spaces from filenames and folders
counter=0

for i in $(find $dir -depth -type f -name *.dcm) # find all files of a specific type
  do
	# use imagemagick to convert from .dcm to .jpg; pass -auto-level else the images turn out too dark
	convert -auto-level $i ${i//.dcm/.jpg}
	counter=$((counter + 1))
	echo -e -n 'working ... \r'
  done

# rename all .jpg after the dir they are in; imagemagick complains about the target dir if I try to wrap it in there
for f in $dir/*/*/*/*.jpg ;do fp=$(dirname "$f"); fl=$(basename "$f"); fnp=${fp//['/']/'_'}; mv $f $fp/$fnp-$fl; done 

# finish performance monitoring
end=$SECONDS
echo "converted" $counter "files in $((end-start)) seconds"

# use rsync to extract all .jpg from working directory to a safe backup location
time rsync --exclude=*.dcm --exclude=*.sh --exclude=*.nix --exclude=*.py --exclude=.envrc --exclude=*.git --stats -rh $dir $dest
