#!/usr/bin/perl -w
# Daniel Packer <dp@danielpacker.org>
# Compare sequences in two fasta files

use strict;
use warnings;
use Bio::SeqIO;
use File::Basename qw(basename);
use Data::Dumper;
use Getopt::Long;
$|=1; # logging not buffered

##############################################################################
# subroutines
sub timestamp
{
  return POSIX::strftime("%Y-%m-%d %H:%M:%S ", localtime);
}


sub main
{
  my $tick = ".";
  my $tickcount = 100*1000;

  my %seqdicts = (
    # filename => [ totalseqs, { SEQ => 1 } ]
  );

  my %subindex = (
    # firstNchars => [ \seq, ... ]
  );

  my $do_subsearch=0;
  my $prefixsearch=0;
  my $res = GetOptions(
    'subsearch' => \$do_subsearch, 
    'prefixsearch=i' => \$prefixsearch
    );

  my $usage = qq(
  Usage: compare_fasta.pl [--subsearch] [--prefixsearch N] -- <file1> <file2>

  The subsearch option eliminates difference sequences that are substrings of sequences in the other file.

  The prefixsearch options indexes sequences by the first N characters and eliminates difference sequences that are prefixes of sequences in the other file as well as those which contained the prefix.

  Both optional arguments have the effect of eliminating duplicate sequences, but substring is much more computationally intensive and is not ideal for a large number of similar sequences (quadratic time).

  For peptide comparison with orfs the prefix search is ideal because it uses an index of the first N characters to speed up the process of finding matches. This isn't as easy to do with substring matches that can be anywhere in the string and would require a much larger index, so it is only implemented for prefixes.
  );
  die $usage unless (scalar(@ARGV)==2);

  print timestamp(), "Reading sequences...";

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
      print $tick if ($count % $tickcount == 0);
      # last if $count > 40*1000;
      #print timestamp, "$fn: $count sequences read\n" if ($count % $tickcount == 0);
    }
    $seqdicts{$fn} = [ $count, {%seqs} ];
  }
  print "done.\n";

  #print Dumper \%seqdicts;

  my %lostseqs = ();
  for my $fn (@ARGV)
  {
    my $rec = $seqdicts{$fn};
    my $count = $rec->[0];
    print timestamp(), "$fn: Comparing $count sequences.\n";
    my $seqs = $seqdicts{$fn}->[1];

    # see if every seq in each file is in the other
    my %undefseqs = ();
    for my $seq (keys %$seqs)
    {
      my $seqcount = $seqs->{$seq}; # number of occurances of seq

      # compare against the other
      my $otherfn = ($fn eq $ARGV[0]) ? $ARGV[1] : $ARGV[0];
      my $otherseqs = $seqdicts{$otherfn}->[1];
      if (not defined $otherseqs->{$seq})
      {
        $undefseqs{$seq}++;
        if ($do_subsearch)
        {
          my $count=0;
          my $total = scalar(keys %$otherseqs);
          for my $otherseq (keys %$otherseqs)
          {
            if ($otherseq =~ /$seq/)
            {
              delete $undefseqs{$seq};
              last;
            }
          }
        }
      }
    }
    $lostseqs{$fn} = {%undefseqs};
  }

  # build the substring index for subsearch
  if ($prefixsearch)
  {
    for my $fn (@ARGV)
    {
      my $seqs = $seqdicts{$fn}->[1];
      for my $seq (keys %$seqs)
      {
        my $substring = substr($seq, 0, $prefixsearch);
        if (not defined $subindex{$fn}->{$substring})
        {
          $subindex{$fn}->{$substring} = [];
        }
        push @{ $subindex{$fn}->{$substring} }, \$seq;
      }
    }
    #print Dumper \%subindex;

    # use subindex to remove substrings (duplicates)
    my %foundseqs = (); # hold found seqs to delete after
    for my $fn (keys %lostseqs)
    {
      my $otherfn = ($fn eq $ARGV[0]) ? $ARGV[1] : $ARGV[0];
      my $lseqs = $lostseqs{$fn};
      my $fnindex = $subindex{$otherfn};
      for my $seq (keys %$lseqs)
      {
        my $substring = substr($seq, 0, $prefixsearch);
        if (defined $fnindex->{$substring})
        {
          for my $match (@{ $fnindex->{$substring} })
          {
            delete $lostseqs{$fn}->{$seq} if ($match eq $seq);
            $foundseqs{$fn}->{$seq}++;
          }
        }
      }
    }

    # delete all the found seqs
    for my $fn (keys %lostseqs)
    {
      my $lseqs = $lostseqs{$fn};
      for my $seq (keys %$lseqs)
      {
        delete $lostseqs{$fn}->{$seq} if (defined $foundseqs{$fn}->{$seq});
      }
    }
  }
  print Dumper \%lostseqs;

  for my $fn (keys %lostseqs)
  {
    my $numunique = scalar(keys %{ $lostseqs{$fn} });
    print timestamp(), "Found $numunique unique sequences in $fn.\n";
  }

  for my $fn (keys %lostseqs)
  {
    my $lseqs = $lostseqs{$fn};
    for my $seq (keys %$lseqs)
    {
      print "$fn\t$seq\n";
    }
  }
  print timestamp(), "compare_fasta.pl finished running.\n";
}

##############################################################################
# run
{
  main();
  exit(0);
}
