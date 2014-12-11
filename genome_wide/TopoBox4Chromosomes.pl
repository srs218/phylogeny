#!/usr/bin/perl

=head1 NAME

 TopoBox4Chromosomes
 Script to apile and create boxes for topologies

=cut

=head1 SYPNOSIS

 TopoBox4Chromosomes [-h] -t <topology_file> -i <input_file> 
                          [-b <box_size>][-R]

=head2 I<Flags:>

=over

=item -t

B<topology_file>          topology file, one column (mandatory)

=item -i

B<input_file>             input file, eight columns (mandatory)

=item -b

B<box_size>               box size (optional)

=item -R

B<round_frequencies>      round frequencies to .1

=item -h

B<help>                   print the help

=back

=cut

=head1 DESCRIPTION

 This scripts parse a topology file with 8 columns:
  -f1 ID            <ignored>
  -f2 groupID       <ignored>
  -f3 chromosome    <used>
  -f4 start_coord   <used>
  -f5 end_coord     <used>
  -f6 frequency     <used>
  -f7 topology      <used>
  -f8 length        <used>

  The output will be one matrix per chromosome Coordinates X Topologies 

=cut

=head1 AUTHORS

  Aureliano Bombarely Gomez.
  (ab782@cornell.edu).

=cut

=head1 METHODS

 NumericBoxGenerator


=cut

use strict;
use warnings;
use autodie;

use Getopt::Std;
use Math::BigFloat;

our ($opt_t, $opt_i, $opt_b, $opt_R, $opt_h);
getopts("t:i:b:Rh");
if (!$opt_t && !$opt_i && !$opt_b && !$opt_R && !$opt_h) {
    print "There are n\'t any tags. Print help\n\n";
    help();
}
if ($opt_h) {
    help();
}

## Get the arguments and check them


my $topofile = $opt_t ||
    die("INPUT ARG. ERROR: -t <topology_file> argument was not supplied.\n");

my $infile = $opt_i || 
    die("INPUT ARG. ERROR: -i <input_file> argument was not supplied.\n");

## Check that box it is numberic

if ($opt_b) {

    if ($opt_b !~ /^\d+$/) {
        die("INPUT ARG. ERROR: -b <box_size> argument is not numeric.\n");
    }
}


## First parse the topofile

my @topologies = ();
my %permtopo = ();
open my $tfh, '<', $topofile;

while(<$tfh>) {

    chomp($_);
    push @topologies, $_;
    $permtopo{$_} = 1;
}

my $topo_n = scalar(@topologies);
print STDERR "\n\t1) $topo_n topologies have been parsed.\n\n";

## Second, now it will parse the results file keeping order of the 
## regions (defined as ChrID_Start_End)


my %regions = ();
my %structs = ();
my %regionlengths = ();

open my $ifh, '<', $infile;
my $total = 0;

while(<$ifh>) {

    chomp($_);
    my @data = split(/\t/, $_);
    my ($id, $grid, $chr, $sta, $end, $frq, $topo, $length) = @data;

    ## round freq

    my $newfreq = $frq;
    if ($opt_R) {
        $newfreq = Math::BigFloat->new($frq)->bfround(-1);
        $data[5] = Math::BigFloat->new($frq)->bfround(-1);
    }

    if (exists $permtopo{$topo}) {

        my $region = $chr . "_" . $sta . "_" . $end;
        $regionlengths{$region} = $length;
 
        if (exists $regions{$region}) {
            
            $regions{$region}->{$topo} = \@data;
        }
        else {
            
            ## Create if doesnt exists an empty matrix with all the topologies
            my %topomtx = ();
            
            foreach my $tp (@topologies) {
            
                if ($tp eq $topo) {
                
                    $topomtx{$tp} = \@data;
                }
                else {
                
                    $topomtx{$tp} = [];
                }
            }
            
            $regions{$region}  = \%topomtx;

            ## Also the data of the region will be added to the structure hash
            ## with the start to be able to other the regions

            $structs{$chr}->{$region} = $sta;
        }
    }
    else {

        print STDERR "\tWARNING: $topo is not a existing topology.\n";
    } 
}

my @reg = keys(%regions);
my $reg_n = scalar(@reg);

print STDERR "\n\t2) $reg_n regions have been parsed.\n\t   Summary:\n";
foreach my $ch (sort keys %structs) {

    my $chr_rg_n = scalar(keys(%{$structs{$ch}}));
    print STDERR "\t\t$ch\t$chr_rg_n\n";
}

## now it will create the freq matrices

my %chr_freq = ();

foreach my $ch (sort keys %structs) {

    my %rg = %{$structs{$ch}};
    $chr_freq{$ch} = {};

    my $prevdata = '';
    my @ordregions = sort {$rg{$a} <=> $rg{$b}} keys %rg;
    my $n = 0;
    foreach my $reg (@ordregions) {
    
        my %topodata = %{$regions{$reg}};
        my $reglength = $regionlengths{$reg};

        ## Now it will check if it can merge with the previous region

        if (ref($prevdata) eq 'HASH') {
        
            my %prevdata = %{$prevdata};
            my %mergdata = ();
            my $allgood = scalar(@topologies);
            my $goodhits = 0;


            foreach my $t (@topologies) {
            
                my @pdata = @{$prevdata{$t}};
                my @cdata = @{$topodata{$t}};
                my @mergetopo = ();
                                
                if (scalar(@pdata) == scalar(@cdata)) {
                
                    if (scalar(@pdata) > 0) {
                    
                        ## Check that the freq is the same
                        if ($pdata[5] == $cdata[5]) {
                        
                            $goodhits++;
                            @mergetopo = ($pdata[0], '', $pdata[2], $pdata[3],
                                          $cdata[4], $pdata[5], $t, 
                                          $pdata[7] + $cdata[7]); 
                        }
                        else {
                        
                            @mergetopo = @pdata;
                        }
                    }
                    else {
                        
                        $goodhits++;                        
                    }
                }
                else {
                
                    @mergetopo = @pdata;
                }
                
                ## Last thing, add the new merged topo
                $mergdata{$t} = \@mergetopo;
            }
        
            ## Merge if all good

            ## If it is not last
            if ($reg ne $ordregions[-1]) {

                if ($goodhits == $allgood) {
                    
                    ## If everything it is okay it will add to the previous
                    $prevdata = \%mergdata;
                    #print STDERR "Merging  $ordregions[$n-1] $reg\n";
                }
                else {
                    
                    ## If not it will print the mergedata and it will add new
                    my @freqs = ();
                    my @heads = ();
                    my $a = 0;

                    foreach my $t (@topologies) {

                        my @t_data = @{$mergdata{$t}};
                        if (scalar(@t_data) > 0) {
                            
                            if ($a == 0) {
                                
                                @heads = ($t_data[2], $t_data[3], $t_data[4]);
                                $a++;
                            }
                            push @freqs, $t_data[5];
                        }
                        else {
                        
                            push @freqs, 0;
                        }
                    }
                    my @pline = (@heads, @freqs);

                    ## Before printing it will check the size of the region
                    ## if exists -b it will divide the region by boxsize

                    my $r_size = $pline[2] - $pline[1];

                    if ($opt_b) {
                        
                        while($opt_b < $r_size) {
                            
                            my @first = @pline;
                            $first[2] = $first[1] + $opt_b;
                            my $f_line = join("\t", @first);
                            print STDOUT "$f_line\n";
                            
                            $pline[1] = $first[2] + 1;
                            $r_size = $pline[2] - $pline[1];
                        }
                    }

                    my $p_line = join("\t", @pline);
                    print STDOUT "$p_line\n";


                    ## Add the previous
                    $prevdata = \%topodata;
                }
            }
            else {  ## Print the last line
            
                ## If not it will print the mergedata and it will add new
                my @freqs = ();
                my @heads = ();
                my $a = 0;
                foreach my $t (@topologies) {

                    my @t_data = @{$mergdata{$t}};
                    if (scalar(@t_data) > 0) {
                        
                        if ($a == 0) {
                            
                            @heads = ($t_data[2], $t_data[3], $t_data[4]);
                            $a++;
                        }
                        push @freqs, $t_data[5];
                    }
                    else {
                    
                        push @freqs, 0;
                    }
                }
                my @pline = (@heads, @freqs);

                ## Before printing it will check the size of the region
                ## if exists -b it will divide the region by boxsize

                my $r_size = $pline[2] - $pline[1];

                if ($opt_b) {
                        
                    while($opt_b < $r_size) {
                            
                        my @first = @pline;
                        $first[2] = $first[1] + $opt_b;
                        my $f_line = join("\t", @first);
                        print STDOUT "$f_line\n";
                        
                        $pline[1] = $first[2] + 1;
                        $r_size = $pline[2] - $pline[1];
                    }
                }

                my $p_line = join("\t", @pline);
                print STDOUT "$p_line\n";
                $prevdata = '';
            }
        }
        else {
        
            ## It means that it is the first

            $prevdata = \%topodata;
        }
        $n++;
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

      This scripts parse a topology file with 8 columns:
       -f1 ID            <ignored>
       -f2 groupID       <ignored>
       -f3 chromosome    <used>
       -f4 start_coord   <used>
       -f5 end_coord     <used>
       -f6 frequency     <used>
       -f7 topology      <used>
       -f8 length        <used>

      The output will be one matrix per chromosome Coordinates X Topologies 

      Usage:
     
      TopoBox4Chromosomes [-h] -t <topology_file> -i <input_file> 
                          [-b <box_size>] [-m <min_percentage>][-R]

			  Flags:

      -t <topology_file>          topology file, one column (mandatory)
      -i <input_file>             input file, eight columns (mandatory)
      -b <box_size>               box size (optional)
      -m <minimum_freq>           min. frequency to consider the box (optional)
      -R <round_freq>             round frequencies to .1
      -h <help>                   print the help

EOF
exit (1);
}
