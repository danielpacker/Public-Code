#!/usr/bin/perl -w 

use strict;
use warnings;

use Bio::Perl;

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
    #my $s2 = $seq; $s2 =~ tr/actgACTG/tgacTGAC/;
    my $s2 = $seq; $s2 =~ tr/AaCcGgTt/TtGgCcAa/;
    return $s2;
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
