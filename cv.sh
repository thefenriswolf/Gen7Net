#!/bin/bash
dir=$1 # store arg1
dest=$2 # store arg2
start=$SECONDS
detox -nvr -s utf_8 $dir
counter=0
for i in $(find $dir -depth -type f -name *.dcm)
  do
	convert -auto-level $i ${i//.dcm/.jpg}
	counter=$((counter + 1))
	echo -e -n 'working ... \r'
  done
end=$SECONDS
echo "converted" $counter "files in $((end-start)) seconds"
