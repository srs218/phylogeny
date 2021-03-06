#!/usr/bin/perl

=head1 NAME

 remove_gaps.pl
 Script to remove gap positions from an alignment based on gaps in reference sequence 

=cut

=head1 SYPNOSIS

 remove_gaps.pl [-h] -i <input_alignment_file> [-o output_basename]
                       [-f <input_format>] [-z output_format]

=head2 I<Flags:>

=over


=item -i

B<input_fasta_file>       input alignment file (mandatory)

=item -d 

B<input dir name>  input directory where input alignment files are found. Use this instead of -i to format multiple alignment files 

=item -o

B<output_basename>        output basename . Defaults to INPUT_FILENAME.OUT_FORMAT #

=item -f

B<in_format>              input format (phylip for mavid output)

=item -s 

B<input suffix>    input file suffix. Defaults to <in_format} ( option -f ). Use this option if your input file(s) have different suffix than <in_format>

=item -z

B<out_format>             output format

=item -r

<B><reference name> name of the reference sequence for finding the gaps

=item -h

B<help>                   print the help

=back

=cut

=head1 DESCRIPTION

 Script to remove gap positions from an alignment using one sequence as a template.  Output format can be specified.

   Examples:

      remove_gaps.pl -i aln.nexus -f INPUT_FORMAT -z nexus  -r REFERENCE -o degapped.nexus
    
      remove_gaps.pl -d ./alignments -f INPUT FORMAT -f phylip -z nexus -r REFERENCE  
=cut

=head1 AUTHORS

 Susan Strickler <srs57@cornell.edu>
 Naama Menda <nm249@cornell.edu>

=cut

=head1 METHODS

    remove_gaps.pl

=cut

use strict;
use warnings;

use Bio::AlignIO;
use Bio::SimpleAlign;
use Getopt::Std;
use Data::Dumper;
use  File::Find::Rule;
use File::Basename; 

our ($opt_i, $opt_o, $opt_f, $opt_z, $opt_d, $opt_s, $opt_r, $opt_h);
getopts("i:o:f:l:z:d:s:r:h");

if (!$opt_i && !$opt_o && !$opt_f && !$opt_z && !$opt_h) {
    print "Please give options. See help.\n\n";
    help();
}

if ($opt_h) {
    help();
}

### Get the arguments and check them
my $inaln_file = $opt_i ; 
#    die("An input alignment was not given (-f <input_aln_file>).\n");

my $in_format = $opt_f;
my $suffix = $opt_s || $in_format;

### Get the arguments and check them
my $dir = $opt_d ;

if ( !$inaln_file && !$dir ) { die("Must provide input alignment file ( -i )  or an input directory ( -d ).\n"); }
if ( $inaln_file && $dir ) { die("Can only provide one option. Input alignemnt file ( -i ) OR input directory ( -d ). \n"); }
my $ref = $opt_r  || die("must provide reference sequence name from the alignment(s) ( -r ) . \n");
my @files;
if ($dir) { print STDERR "dir = $dir suff = $suffix \n"; }

if ($inaln_file) {
    @files = ( $inaln_file ) ;
} elsif ($dir) {
    @files = File::Find::Rule->file()
	->name( "*.$suffix" )
	->maxdepth( 2 )
	->in( $dir );
}

foreach my $file (@files) {

    my $input_aln = Bio::AlignIO->new(-file => $file,
				      -format => $in_format
	);

    my $aln = $input_aln->next_aln();
    my $dirname  = dirname($file);
    my $basename = basename($file , ( $suffix, $in_format ) ) ;
    my $out_format = $opt_z;
    my $out_name  = $opt_o || $dirname . "/" .  $basename . "degap." . $out_format;
    if ( -e "$out_name" && -s "$out_name" ) {
	print "File $out_name exists. Skipping \n\n";
	next();
    }
    print "De-gapping file $file . outfile = $out_name \n";

    my $out_aln = Bio::AlignIO->new( 
	-file   => ">$out_name",
	-format => $out_format
	);  

###gap_col_matrix generates an array of hashes where each entry in the array is a hash reference with keys 
###of all the sequence names and a value of 1 for gap or 0 for no gap at that column
    my $cols = $aln->gap_col_matrix();

    my @ref_gaps;
    my $length = 0;
    my $coord = 0;
    my $prev_gap_status = 0;

###Select all reference genome keys, number to get coordinate in genome, and store gap coordinate in an array
###Dereference array                                                                                                                                       
    my @cols = @{$cols};

#print Data::Dumper::Dumper($cols);

    foreach my $col(@cols){
                                        #	print "My key equals $key, value equals ". $col->{$key} . "\n";    
	my $gap_status = $col->{$ref};
	
	if ($gap_status == 1){
	    $length++;
	}
    
	elsif ( ($gap_status != 1) && ($prev_gap_status == 1) ){
	    my $start_coord = $coord - $length;
	    my $end_coord = $coord -1 ;
	    push @ref_gaps, [$start_coord,$end_coord];
	    print "coord: $coord length: $length. This is gap start $start_coord and end $end_coord \n";
	    $length = 0;

	}
	
    ##Add something to get last gap
	
	$prev_gap_status = $gap_status;
	$coord++;
    }

###Remove all columns that create a gap in the reference
    my $degapped_aln = $aln->remove_columns(@ref_gaps);  
    $out_aln->write_aln($degapped_aln);
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

       A script to remove gaps in the reference genome of a mavid/mercator alignment

	 Usage:

       remove_gaps.pl [-h] -i <input_alignment_file> [-o output_basename]                                                                                                                                                                                                             
                       [-f <input_format>] [-z output_format]

     Flags:

      -i <aln_file>              input alignment file 
      -d <aln_dir>               input alignment dir
      -o <output_basename>       basename for degapped alignment
      -f <input_format>          alignment format of input
      -z <output_format>         alignment format for output
      -s <output_suffix>         suffix for output file(s)
      -r <reference_name>        name of the reference sequence in the alignment(s)

EOF
exit (1);
}


