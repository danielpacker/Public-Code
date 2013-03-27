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

die "provide two input filenames!" unless (scalar(@ARGV) == 2);

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

print "Comparing sequences...\n";

my %lostseqs = ();
for my $fn (@ARGV)
{
  my $rec = $seqdicts{$fn};
  my $count = $rec->[0];
  print "$fn: Comparing $count sequences.\n";
  my $seqs = $seqdicts{$fn}->[1];

  # see if every seq in each file is in the other
  for my $seq (keys %$seqs)
  {
    my $seqcount = $seqs->{$seq}; # number of occurances of seq

	print "HRM $fn $seq\n" if ($seq =~ /XXDP/);
    # compare against the other
    my $otherfn = ($fn eq $ARGV[0]) ? $ARGV[1] : $ARGV[0];
    my $otherseqs = $seqdicts{$otherfn}->[1];
    if (! defined $otherseqs->{$seq})
    {
      #print "$seq is in $fn but not in $otherfn!\n";
      $lostseqs{$fn} = $seq;
    }
  }
}

print "done.\n";

my $numunique = scalar(keys %lostseqs);

print "Found $numunique unique sequences:\n";

for my $fn (keys %lostseqs)
{
  my $seq = $lostseqs{$fn};
  print "$fn\t$seq\n";
}
