#!/usr/bin/perl

=head1 NAME

 format_for_mrbayes.pl
 
 A script to format nexus alignment format for the Mr. Bayes phylogeny software

=cut

=head1 SYPNOSIS

 format4mrbayes.pl [-h] -i <aln_dir> [-b bin_size]


=head2 I<Flags:>

=over

=item -i

B<aln_dirs>               input alignment directory.  This is a directory containing the subdirectories produced my Mavid/Mercator

=item -b

=item -h

B<help>                   print the help

=back

=cut

=head1 DESCRIPTION

Preps nexus files for Mr. Bayes input.  Used in whole genome phylogenies from Mercator/Mavid after gaps have been removed with remove_gaps.pl. It automatically partition into bins based on the given input size and creates the partition file

   Examples:

    format4mrbayes.pl -i aln_dir/ -b 100000

=cut

=head1 AUTHORS

 Susan Strickler
 srs57@cornell.edu

=cut

=head1 METHODS

    format4mrbayes.pl

=cut


use strict;
use warnings;
use Getopt::Std;
use File::Find::Rule;

our ($opt_i, $opt_b, $opt_h);
getopts("i:b:h");

if (!$opt_i && !$opt_b && !$opt_h) {
    print "Please give options. See help.\n\n";
    help();
}

if ($opt_h) {
    help();
}

### Get the arguments and check them
my $dir = $opt_i || die("An input alignment directory was not given (-i <aln_dir>).\n");

my $bin_size = $opt_b ||  die("A bin size was not given (-b <bin_size>).\n");

#my $dir = $ARGV[0];
my @files = File::Find::Rule->file()
                                  ->name( "*.nexus" )
                                  ->maxdepth( 2 )
                                  ->in( $dir );
 
##input loc of aln
my $sequence;

foreach my $file (@files){
    chomp $file;
  
     #Open input file                                                                                                                                                               
    open (INALN, "<$file") || die "Cannot open nexus file.\n";


    ##Open input file                                                                                     
    open (INALN, "<$file") || die "Cannot open nexus file.\n";
          
    $sequence = "";
    my $end_coord = "";
  
    while(<INALN>){
	my $line = $_;
  	
	if ($line =~ /^format/){
	    $sequence .= "format interleave=yes datatype=dna gap=-;";
	}

	elsif($line  =~ /(dimensions ntax=5 nchar=)(.*)(;)/){
	    $end_coord = $2;
	    $sequence .= $line;
	}

	else {
	    $sequence .= $line;
	}
    }
    
    my @num_parts = ();
    my @exclude_sets = ();
    
    ##Make partitions at end of file for Mr. Bayes analysis
    my $start_exclude = 1;
    my $end_exclude = $bin_size; #100000;
    my $group = 1;
    my $num_parts = 0;
    my $new_line;

    ##Get number of partitions
    while($end_exclude < $end_coord){
	$new_line = $start_exclude . "-" . $end_exclude . ";\n"; 
	push (@exclude_sets, $new_line);
	$group++;
	$num_parts++;
	push (@num_parts, $num_parts);
	$start_exclude += $bin_size;
	$end_exclude += $bin_size;
    }

    ##Get last partition
    $new_line = $start_exclude . "-" . $end_coord . ";\n"; 
    push (@exclude_sets, $new_line);
    $num_parts++;
    push (@num_parts, $num_parts);

    ##Generate individual partition files for Mr. Bayes input                                                                                      
    my $file_count = 1;
    
    #generate partitions file\
    open (OUTFILE, ">$file.mb") ||die "Can't open mb outfile.\n";
    print OUTFILE "begin mrbayes;\n";

    foreach my $exclude_set(@exclude_sets){
        print OUTFILE "charset\t" . $exclude_set;
    }

    while($file_count <= $num_parts){

	#Open out file                                                                                          
	open (OUTFILE, ">>$file.group$file_count.nexus") || die "Can't open output file.\n";
	
	#Print sequence and charset from earlier into each file                                                                                    
	print OUTFILE $sequence ;
	print OUTFILE "begin mrbayes;\n";
	
	my $include = shift(@exclude_sets);
	
	foreach my $exclude_set(@exclude_sets){	
	    print OUTFILE "exclude " . $exclude_set;
	}

	push (@exclude_sets, $include);	

	#Print final Mr. Bayes analysis stanza                                                                                                                                
	print OUTFILE "Outgroup potato;\n";
	print OUTFILE "mcmc Mcmcdiagn=yes ngen=200000 samplefreq=100 printfreq=1000 diagnfreq=5000 relburnin=yes burninfrac=0.2 nchains=3 temp=0.25 nruns=3;\n";
	print OUTFILE "sumt burnin=250 calctreeprobs=yes showtreeprobs=yes;\n";                                   print OUTFILE "lset applyto=(all) nst=6 rates=invgamma;\n";
	print OUTFILE "prset applyto=(all) ratepr=variable topologypr=uniform ;\n";                               print OUTFILE "end;\n";
	
	$file_count++;
	
	close (OUTFILE);
    }
}


=head2 help

  Usage: help()
  Desc: print help of this script
  Ret: none
  Args: none
  Side_Effects: exit of the script
  Example: if (!@ARGV) {
               help();
           }

=cut

sub help {
    print STDERR <<EOF;
  $0:

  Description:

       A script to format a directory with subdirectories of nexus alignments for the Mr. Bayes phylogeny software
 
  Usage:
       
       format4mrbayes.pl [-h] -i <aln_dir> [-b bin_size]

     Flags:

      -i <aln_dir>        input dir (mandatory)
      -b <bin_size>       bin size to partition alignment
      -h <help>           print the help
     

EOF
exit (1);
}


