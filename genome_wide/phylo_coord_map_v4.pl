#!/usr/bin/perl

##For mapping Mr. Bayes output on mdl partitions to reference genome coordinates based on Mavid alignments
##To use: go to directory containing subdirs of mr. bayes output: ./phylo_coord_map2.pl trees/ coverage.csv
##need to sort output file before plotting - add this

use strict;
use warnings;
use File::Slurp;
use File::Basename;

##Get the directories
if (!$ARGV[0]){
    print "Give a directory containing the partition (.mb) file and .trprobs files. \n";
    exit 1;
}

##Get the genome coordinate files
if (!$ARGV[1]){
    print "Give coord. \n";
    exit 1;
}

#Get input 
my $dir = $ARGV[0];
my @dirs = `find $dir/* -type d`;
my $gen_coord = $ARGV[1];

##Get information for each input directory
foreach my $dir (@dirs){
    chomp $dir;
    my @bayes_files = ();
    @bayes_files = glob("$dir/*.trprobs");
    
    if (@bayes_files == 0){
	print "No tree probablities found for dir " . $dir . "\n";
    }

    my $mb_path = $dir . "/mavid.phy.gap_removed.nexus.nexus.mb";
  
    ##open genome coordinate mapping file  
    open (INCOORD, "<$gen_coord") || die "Cannot open genome coordinate file.\n";

    ##open Mr. Bayes partitions file
    open (PART, "<$mb_path") || die "Cannot open partitions file for directory $dir. \n";
   
    ##hash for genome coordinate mapping file content
    my %coord_ids;
    
    ##Read and store in hash group, chromosome, and genome start coordinate.
    while (<INCOORD>){
	chomp;
	my ($aln_id, $chromo, $start_coord, $end_coord) = split (/\t/, $_);
	my $all_coord = $chromo . "\t" . $start_coord . "\t" . $end_coord . "\n";
	$coord_ids{$aln_id} = $all_coord if defined $all_coord;    
    }
    
    ##hash for partition groups and start and end coordinates
    my %partition_coords;
    
    ##Read and store in hash group, start, end coordinates.
    my $group = 0;
    while (<PART>){
	chomp;
	my $part_line = $_;
	
	if ($part_line =~ /(^charset)(\t)(.*)(-)(.*)(;)/){
	    $group++;
	    my $grp_coords = $3 . "\t" . $5;
	    my $group_num = "group" . $group;
	    my $partition_coords -> {$group_num} = $grp_coords;
	    $partition_coords{$group_num} = $grp_coords if defined $grp_coords;
#	    print  "This is partition " . $partition_coords{$group} . "\n";
	}
	
	else {next;}
    }
        
    #Open out file #fileslurp use it                                                                              
    open (OUTFILE, ">>mapping_file.out") || die "Can't open output file.\n";
    
    ##Read Mr Bayes out files
    foreach my $bayes_file(@bayes_files){
	chomp $bayes_file;
	
	my $filename = basename($bayes_file);
	my $path2mb = dirname($bayes_file);

	$path2mb =~ /(.*)(\/)([0-9]{1,3})/;
	my $curr_group = $3;

	$filename =~ s/.*(group.*)\.nexus.trprobs/$1/;
	my $group_name = $filename;

	##open mr. bayes file
	open (INBAYES, "<$bayes_file") || die "Cannot open Mr.Bayes file.\n";
	
	##Extract info from Mr. Bayes file - trees and probabilities
	while (<INBAYES>){
	    chomp;
	    my $bayes_line = $_;
	    
	    if ($bayes_line =~ /(   tree tree_.{1,3} \[p = .\...., P = .\....\] = \[&W )(.\.......)(\] )(\(.*\);)/){ 
		my $prob = $2;
		my $tree = $4;
		
		if (exists ($coord_ids{$curr_group})){
		    my $all_coords2 = $coord_ids{$curr_group};
		    my ($chromo2, $st_coord2, $end_coord2) = split (/\t/,$all_coords2);
		    
		    print "dir is " . $dir . "\t" . "curr_group is " . $curr_group . "\tgroup name is " . $group_name . "\n";
   
		    if (exists ($partition_coords{$group_name})){
			my $grp_coord = $partition_coords{$group_name};
			my ($grp_st_coord, $grp_end_coord) = split (/\t/, $grp_coord);
			my $heinz_st_coord = $st_coord2 + $grp_st_coord; 
			my $heinz_end_coord = $st_coord2 + $grp_end_coord;
			print OUTFILE $curr_group . "\t" . $group_name . "\t" . $chromo2 . "\t" . $heinz_st_coord . "\t" . $heinz_end_coord . "\t" . $prob . "\t" . $tree . "\n";
		    }
		    
		    else {
			print "Cannot find data for dir $dir.\n";
		    }
		}
		
		else {
		    print "Cannot find data2 for dir $dir.\n";}
	    }
	    
	    else{
		next;
	    }

	}
    }
}
	    
