#!/bin/bash

#pipline for running parallel remove_gaps.pl
#
#   run_remove_gaps.sh  $basedir $start_dir $end_dir $reference_name
#
###################
##
#input_file-directory=$1

basedir=$1
reference_name=$2

dirarray=()


index=0
for subdir in  "$basedir"/[1-9]*   ; do 
    #echo "dirname = $subdir"
    dirarray[${index}]=$subdir
    ((index++))
done

dir_count=${#dirarray[@]}
echo "Number of sub dirs = $dir_count " 


file_index=0

for ((i=1; i<$dir_count+1; i++)); do
    if [ $((file_index)) = $((dir_count)) ]
    then
	echo "Finished last dir number $dir_count"
	exit
    fi
    aln_dir=${dirarray[$file_index] }
    echo "perl remove_gaps.pl  -i  $aln_dir/mavid.phy -f phylip -z nexus -r $reference_name -s phy" | qsub
	#echo "align dir = $aln_dir , file index = $file_index"
    echo "run number $i. align_dir = $aln_dir"
    ((file_index++))
    
done
