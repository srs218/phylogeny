#!/bin/bash

#pipline for running parallel MrBayes
#   run_mrbayes.sh  $basedir
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

    for group_file in "$aln_dir"/*"group"*".nexus" ; do
	echo "mpirun -np 3 mb $group_file" | qsub

    done
    
    ((file_index++))
done



