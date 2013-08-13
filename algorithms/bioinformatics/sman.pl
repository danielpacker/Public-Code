#!/usr/bin/perl -w
#
# Daniel Packer <dp@danielpcaker.org>
#
# sman.pl is a simple command line utility for
# quick and basic DNA/RNA/protein sequence manipulations

use strict;
use warnings;

use Bio::Perl;
use Getopt::Long;

my $verbose = 0;
my $result = GetOptions ("verbose"  => \$verbose, "v" => \$verbose);  # flags

# do operations on sequences
my $usage = "Usage: sman.pl OPERATION SEQUENCES...";
my $op = $ARGV[0] or die $usage;
my $seq = uc($ARGV[1]) or die $usage;

#print "$usage\n$seq\n$op\n";

################## routines #######################

sub do_op {

  if ($op =~ /^rev/i) # reverse 
  {
    my @chars = reverse( split("", $seq) );
    return join("", @chars);
  }
  elsif ($op =~ /^rc/i) # reverse complement
  {
    my $rc = revcom($seq)->seq();
    return $rc;
  }
  elsif ($op =~ /^com/i) # complement
  {
    my $s2 = $seq; $s2 =~ tr/AaCcGgTt/TtGgCcAa/;
    return $s2;
  }
  elsif ($op =~ /^tran/i) # translate
  {
    my $seqobj = Bio::Seq->new(-seq => $seq, -alphabet => 'dna' );
    my $prots_str = "";
    for my $frame (1..3) {
      my $prot = $seqobj->translate(-frame => $frame-1, -start=>"ATG");
      my $prot_str;

      if ($verbose) # in versbose mode show codon alignment, original seq
      {
        my @aas = split("", $prot->seq());
        $prot_str = "  $seq\n" . "$frame " . "-" x ($frame-1) . 
          join("", map { "[$_]"} @aas) . "\n\n";
      }
      else # basic info
      {
        $prot_str = "$frame " . $prot->seq() . "\n";
      }
      $prots_str .= $prot_str;

    }
    return $prots_str;
  }
}

sub main {
  print do_op(), "\n";
  exit(0);
}

###################### run ##########################
{
  main();
}
