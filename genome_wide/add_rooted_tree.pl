#!/usr/bin/perl

##Add rooted trees to mapping file

use strict;
use warnings;

##Get the file
if (!$ARGV[0]){
    print "Give a tree mapping file.";
    exit 1;
}

#Get input 
my $infile_name = $ARGV[0];

#Open input file
open (INFILE, "<$infile_name") || die "Cannot open in file.\n";

my $utree;
my ($col1, $col2, $col3, $col4, $col5, $col6);

#Read and store file content 
while (<INFILE>){
    chomp;
    my ($col1, $col2, $col3, $col4, $col5, $col6, $utree) = split (/\t/,$_);

    if ($utree =~ /\(2,\(\(5,4\),3\),1\);/){
	print $col1 . "\t" . $col2 . "\t" . $col3 . "\t" . $col4 . "\t" . $col5 . "\t" . $col6 . "\t" . "((((1,2),3),4),5);\n";
    }
 
    elsif ($utree =~ /\(2,\(4,\(5,3\)\),1\);/){
	print $col1 . "\t". $col2 . "\t" . $col3 . "\t". $col4 . "\t" . $col5 . "\t". $col6 . "\t" . "((((1,2),4),3),5);\n";
    }

    elsif ($utree =~ /\(2,\(5,\(4,3\)\),1\);/){
	print $col1 . "\t". $col2 . "\t" . $col3 . "\t". $col4 . "\t" . $col5 . "\t". $col6 . "\t" . "(((1,2),(3,4)),5);\n";
    }

    elsif ($utree =~ /\(\(4,2\),\(5,3\),1\);/){
	print $col1 . "\t". $col2 . "\t" . $col3 . "\t". $col4 . "\t" . $col5 . "\t". $col6 . "\t" . "((((2,4),1),3),5);\n";
    }

    elsif ($utree =~ /\(\(4,\(5,2\)\),3,1\);/){
	print $col1 . "\t". $col2 . "\t" . $col3 . "\t". $col4 . "\t" . $col5 . "\t". $col6 . "\t" . "((((1,3),4),2),5);\n";
    }

    elsif ($utree =~ /\(4,\(\(5,2\),3\),1\);/){
	print $col1 . "\t". $col2 . "\t" . $col3 . "\t". $col4 . "\t" . $col5 . "\t". $col6 . "\t" . "((((1,4),3),2),5);\n";
    }

    elsif ($utree =~ /\(4,\(5,\(2,3\)\),1\);/){
	print $col1 . "\t". $col2 . "\t" . $col3 . "\t". $col4 . "\t" . $col5 . "\t". $col6 . "\t" .  "(((1,4),(3,2),5);\n";
    }

    elsif ($utree =~ /\(\(5,2\),\(4,3\),1\);/){
	print $col1 . "\t". $col2 . "\t" . $col3 . "\t". $col4 . "\t" . $col5 . "\t". $col6 . "\t" . "((((3,4),1),2),5);\n";
    }

    elsif ($utree =~ /\(\(\(5,4\),2\),3,1\);/){
	print $col1 . "\t". $col2 . "\t" . $col3 . "\t". $col4 . "\t" . $col5 . "\t". $col6 . "\t" . "((((1,3),2),4),5);\n";
    }

    elsif ($utree =~ /\(\(5,\(4,2\)\),3,1\);/){
	print $col1 . "\t". $col2 . "\t" . $col3 . "\t". $col4 . "\t" . $col5 . "\t". $col6 . "\t" . "(((1,3),(2,4),5);\n";
    }

    elsif ($utree =~ /\(\(5,4\),\(2,3\),1\);/){
	print $col1 . "\t". $col2 . "\t" . $col3 . "\t". $col4 . "\t" . $col5 . "\t". $col6 . "\t" . "((((2,3),1),4),5);\n";
    }

    elsif ($utree =~ /\(5,\(\(4,2\),3\),1\);/){
	print $col1 . "\t". $col2 . "\t" . $col3 . "\t". $col4 . "\t" . $col5 . "\t". $col6 . "\t" . "((((2,4),3),1),5);\n"
    }

    elsif ($utree =~ /\(5,\(2,\(4,3\)\),1\);/){
	print $col1 . "\t". $col2 . "\t" . $col3 . "\t". $col4 . "\t" . $col5 . "\t". $col6 . "\t" . "(((4,3),(2,1)),5);\n";
    }

   elsif ($utree =~ /\(5,\(2,\(4,3\)\),1\);/){
        print $col1 . "\t". $col2 . "\t" . $col3 . "\t". $col4 . "\t" . $col5 . "\t". $col6 . "\t" . "(5,(1,(2,(3,4))));\n";
    }

    elsif ($utree =~ /\(4,\(2,\(5,3\)\),1\);/){
	print $col1 . "\t". $col2 . "\t" . $col3 . "\t". $col4 . "\t" . $col5 . "\t". $col6 . "\t" . "(5,(3,(2,(4,1))));\n";
    }

    elsif ($utree =~ /\(5,\(4,\(2,3\)\),1\);/){
	print $col1 . "\t". $col2 . "\t" . $col3 . "\t". $col4 . "\t" . $col5 . "\t". $col6 . "\t" . "(5,(1,(4,(2,3))));\n";
    }

    else {print "Error!\n"}
}
