#!/usr/bin/perl

=head1 NAME

fasta_utils -- various fasta file utils 

=cut

package fasta_utils;

use strict;
use warnings;

use Bio::SeqIO;

use constant DEFAULT_MAXSEQS => 10*1000;
use constant DEFAULT_GUESS_CHARS => 10000*1024;

# return number of sequences, average seq length, and total length of all seqs
sub fasta_stats
{
  my %args = @_;
  my $filename = $args{'filename'} or die "no filename";
  my $maxseqs = $args{'maxseqs'};
  $maxseqs = defined($args{'maxseqs'}) ? $args{'maxseqs'} : DEFAULT_MAXSEQS;
  my $do_freq_dist = $args{'freq_dist'} || 0;

  my (%freq_dist, %size_dist);

  my $in = new Bio::SeqIO(-file => $filename, -format => 'fasta');
  my $count = 1;
  my $len = 0;
  while(my $seq = $in->next_seq) {
    $len += $seq->length();
    $size_dist{$seq->length()}++;
    $freq_dist{$seq->display_id()}++ if ($do_freq_dist); # gather freq dist if needed
    last if ($count == $maxseqs);
    $count++;
  }
  my %ret = (
    'count' => $count-1, 
    'avg_length' => $len/$count, 
    'total_length' => $len,
    'size_dist' => {%size_dist}
  );
  %ret = (%ret, 'freq_dist' => {%freq_dist}) if ($do_freq_dist);
  return %ret;
}

# read a fixed number of bytes of the fasta file and guess number of sequences
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

=head2 split_fasta('input' => 'in_file.fa', 'count' => 123)

takes 'input' and 'count' named params. input is the input file and prefix of 
output files which are named input.1, input.2, ... intput.N count is the max 
number of sequences per file. If count is 0, only one file is created.

=cut

sub split_fasta(@)
{
  my %args = @_;
  my $file_in = $args{'file'} || die "no file";    # fasta file
  my $max = $args{'max'} || die "no count";        # num seqs per file

  my $filenum = 1;
  my $c=0;

  my $in  = new Bio::SeqIO(-file  => $file_in) or die "can't open $file_in";
  my $out = new Bio::SeqIO(-file => ">$file_in.$filenum", -format=>'fasta');

  while (my $seq = $in->next_seq) 
  {
    if ($max && ($c % $max == 0)) # start a new file unless $count == 0
    {
      $out = new Bio::SeqIO(-file => ">$file_in.$filenum", -format=>'fasta');
      $filenum++;
    }
    $out->write_seq($seq);
    $c++;
  }
}



=head1 AUTHOR

Daniel Packer <dp@danielpacker.org>

=cut


1;
