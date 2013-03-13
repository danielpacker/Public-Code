#!/usr/bin/perl
#
# Get average read length from fastq file(s). Can be used for rough validation.
# Author: Daniel Packer <dp@danielpacker.org>
#
# usage: fastqinfo.pl <file1> ...more files...

use warnings;
use strict;

my @files = (@ARGV);
my %results;

my $total_all=0;
my $avg_all=0;
my $reads_all=0;

for my $fq (@files)
{
  my $total=0; my $reads=0;
  open(my $fh, "<", $fq) or die "Invalid file '$fq'";
  while (defined(my $line = <$fh>))
  {
    if ($line =~ /^@/)
    {
      my $opt; my $qlt;
      defined(my $seq = <$fh>) or die "Missing seqeuence line at line $. in file '$fq'";
      (defined($opt = <$fh>) && ($opt =~ /^\+/)) or
        die "missing option line at line $. in file '$fq'";
      (defined($qlt = <$fh>) && (length($seq)==length($qlt))) or 
        die "missing or invalid quality line at line $. in file '$fq'";
      chomp($seq);
    
      $total += length($seq);
      $reads++;
    }
  }
  close $fh;
  my $avg = $total / $reads;
  $results{$fq} = {'reads'=>$reads,'avg'=>$avg};
  $total_all += $total;
  $reads_all += $reads;
}

for my $fq (keys %results)
{ 
  my $res = $results{$fq};
  my $reads = $res->{'reads'}; my $avg = $res->{'avg'};
  print "$fq: Average read length over $reads reads: ", $avg, "\n";
}

if ($reads_all > 0 && scalar(@files) > 1)
{
  $avg_all = $total_all / $reads_all;
  print "Average read length over all ", scalar(@files), " files and $reads_all reads is $avg_all\n";
}
