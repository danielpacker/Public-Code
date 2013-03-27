#!/usr/bin/perl -w
# Daniel Packer <dp@danielpacker.org>
# Compare sequences in two fasta files

use strict;
use warnings;

my $tick = ".";
my $tickcount = 10*1000;

use Bio::SeqIO;

$|=1;

my %seqdicts = (
  # filename => [ totalseqs, { SEQ => 1 } ]
);

die "Usage: compare_fasta.pl <file1> <file2>" unless (scalar(@ARGV) == 2);

print "Reading sequences...";

for my $fn (@ARGV)
{
  die "File $fn not found." unless (-e $fn);
  my $in  = Bio::SeqIO->new(-file => $fn, '-format' => 'Fasta');

  $seqdicts{$fn} = [];
  my %seqs = ();
  my $count=0;
  while (my $seq = $in->next_seq()) 
  {
    my $ss = $seq->seq();

    $seqs{$ss}++;
    $count++;
#    last if $count > 40*1000;
    print $tick if ($count % $tickcount == 0);
  }
  $seqdicts{$fn} = [ $count, {%seqs} ];
}
print "done.\n";

use Data::Dumper;
#print Dumper \%seqdicts;

my %lostseqs = ();
for my $fn (@ARGV)
{
  my $rec = $seqdicts{$fn};
  my $count = $rec->[0];
  print "$fn: Comparing $count sequences.\n";
  my $seqs = $seqdicts{$fn}->[1];

  # see if every seq in each file is in the other
  my %undefseqs = ();
  for my $seq (keys %$seqs)
  {
    my $seqcount = $seqs->{$seq}; # number of occurances of seq

    # compare against the other
    my $otherfn = ($fn eq $ARGV[0]) ? $ARGV[1] : $ARGV[0];
    my $otherseqs = $seqdicts{$otherfn}->[1];
    $undefseqs{$seq}++ if not defined $otherseqs->{$seq};
    
  }
  $lostseqs{$fn} = {%undefseqs};
}

for my $fn (keys %lostseqs)
{
  my $numunique = scalar(keys %{ $lostseqs{$fn} });
  print "Found $numunique unique sequences in $fn.\n";
}

for my $fn (keys %lostseqs)
{
  my $lseqs = $lostseqs{$fn};
  for my $seq (keys %$lseqs)
  {
    print "$fn\t$seq\n";
  }
}
