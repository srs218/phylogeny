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

=item -o

B<output_basename>        output basename (by default it will printed as stdout)

=item -f

B<in_format>              input format (phylip for mavid output)

=item -z

B<out_format>             output format

=item -h

B<help>                   print the help

=back

=cut

=head1 DESCRIPTION

 Script to remove gap positions from an alignment using one sequence as a template.  Output format can be specified.

   Examples:

      remove_gaps.pl -i aln.nexus -f input_format > degapped.nexus

=cut

=head1 AUTHORS

 Susan Strickler

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

our ($opt_i, $opt_o, $opt_f, $opt_z, $opt_h);
getopts("i:o:f:l:z:h");

if (!$opt_i && !$opt_o && !$opt_f && !$opt_z && !$opt_h) {
    print "Please give options. See help.\n\n";
    help();
}

if ($opt_h) {
    help();
}

### Get the arguments and check them
my $inaln_file = $opt_i || 
    die("An input alignment was not given (-f <input_aln_file>).\n");

my $in_format = $opt_f;
my $input_aln = Bio::AlignIO->new(-file => $inaln_file,
                                  -format => $in_format
                                 );

my $aln = $input_aln->next_aln();

my $out = $opt_o;
my $out_format = $opt_z;
my $out_aln;

if (defined $out) {
    my $out_name = $out . "." . $out_format;
    $out_aln = Bio::AlignIO->new( 
                                 -file   => ">$out_name",
                                 -format => $out_format
	                        );  
}

else {
    $out_aln = Bio::AlignIO->new( -format => $out_format );
}

###gap_col_matrix generates an array of hashes where each entry in the array is a hash reference with keys 
###of all the sequence names and a value of 1 for gap or 0 for no gap at that column
my $cols = $aln->gap_col_matrix();

my @heinz_gaps;
my $length = 0;
my $coord = 0;
my $prev_gap_status = 0;

###Select all heinz keys, number to get coordinate in genome, and store gap coordinate in an array
###Dereference array                                                                                                                                       
my @cols = @{$cols};

#print Data::Dumper::Dumper($cols);

foreach my $col(@cols){
                                        #	print "My key equals $key, value equals ". $col->{$key} . "\n";    
    my $gap_status = $col->{"heinz"};
	
    if ($gap_status == 1){
	$length++;
    }
    
    elsif ( ($gap_status != 1) && ($prev_gap_status == 1) ){
	my $start_coord = $coord - $length;
	my $end_coord = $coord -1 ;
	push @heinz_gaps, [$start_coord,$end_coord];
	print "coord: $coord length: $length. This is gap start $start_coord and end $end_coord \n";
	$length = 0;

    }

    ##Add something to get last gap
	
    $prev_gap_status = $gap_status;
    $coord++;
}

###Remove all columns that create a gap in Heinz
my $degapped_aln = $aln->remove_columns(@heinz_gaps);  
$out_aln->write_aln($degapped_aln);
 
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

      -i <aln_dir>               input alignment file (mandatory)
      -o <output_basename>       basename for degapped alignment
      -f <input_format>          alignment format of input
      -z <output_format>         alignment format for output


EOF
exit (1);
}


