#!/usr/bin/perl

package fasta_utils;

use strict;
use warnings;

use Bio::SeqIO;

use constant DEFAULT_MAXSEQS => 10*1000;
use constant DEFAULT_GUESS_CHARS => 10000*1024;

sub fasta_stats($;$)
{
  my $filename = shift or die "no filename";
  my $maxseqs = shift;
  $maxseqs = defined($maxseqs) ? $maxseqs : DEFAULT_MAXSEQS;

  my $in = new Bio::SeqIO(-file => $filename, -format => 'fasta');
  my $count = 1;
  my $len = 0;
  while(my $seq = $in->next_seq) {
    $len += $seq->length();
    last if ($count == $maxseqs);
    $count++;
  }
  return (
    'count' => $count, 
    'avg_length' => $len/$count, 
    'total_length' => $len
  );
}

sub guess_num_seqs($)
{
  my $filename = shift or die "no filename";

  my $data;
  open my $fh, "<$filename"
    or die "Can't open file $filename for reading";
  my $bytes = read($fh, $data, DEFAULT_GUESS_CHARS);
  close $fh or die "Can't close file $filename";

  my $count =()= $data =~ /^\>[A-Za-z0-9_]+ ?/gm;

  return $count if ($bytes < DEFAULT_GUESS_CHARS);

  my $filesize = -s $filename;

  my $guessed_num_seqs = $count * ($filesize / DEFAULT_GUESS_CHARS);

  return int($guessed_num_seqs);
}




1;
