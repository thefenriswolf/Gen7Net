#!/bin/bash
dir=$1 # store arg1
dest=$2 # store arg2
start=$SECONDS
counter=0
for i in $(find $dir -depth -type f -name *.jpg)
  do
	rm $i
	counter=$((counter + 1))
	echo -e -n 'cleaning working directory ... \r'
  done
end=$SECONDS
echo "cleaned" $counter "files in $((end-start)) seconds"
