#!/usr/bin/perl -w

use Bio::Perl;
use strict;

my $database = "genbank";
my @accessions = qw/
  CP001438.1
/;

for (@accessions) {
  my $filename = $_ . ".fasta";
  print "FILENAME: $filename\n";
  my $format = "fasta";
  my $sequence = get_sequence($database, $_);
  write_sequence(">$filename", $format, $sequence);
  sleep(1);
}
