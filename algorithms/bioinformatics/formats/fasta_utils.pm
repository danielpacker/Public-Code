#!/usr/bin/perl

package fasta_utils;

use strict;
use warnings;

use Bio::SeqIO;

sub fasta_stats($;$)
{
  my $filename = shift or die "no filename";
  my $maxseqs = shift || 1000;

  my $in = new Bio::SeqIO(-file => $filename, -format => 'fasta');
  my $count = 0;
  my $len = 0;
  while(my $seq = $in->next_seq) {
    $len += $seq->length();
    last if ($count++ == $maxseqs);
  }
  return (
    'count' => $count, 
    'avg_length' => $len/$count, 
    'total_length' => $len
  );
}

1;
