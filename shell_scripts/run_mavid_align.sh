#!/bin/bash

#pipline for running parallel mavidAlignDirs
#   run_mavid_align.sh  $basedir
#
###################
##
#input_file-directory=$1

basedir=$1
dirarray=()

index=0
for subdir in  "$basedir"/[1-9]*   ; do 
    #echo "dirname = $subdir"
    dirarray[${index}]=$subdir
    ((index++))
done

dir_count=${#dirarray[@]}
echo "Number of sub dirs = ${#dirarray[@]} " 

file_index=0

for ((i=1; i<$dir_count+1; i++)); do

    if [ $((file_index)) = $((dir_count)) ]
    then
	echo "Finished last dir number $dir_count"
	exit
    fi

    aln_dir=${dirarray[$file_index] }

    echo "mavidAlignDirs --init-dir=$aln_dir --skip-completed" | qsub

    ((file_index++))

done
