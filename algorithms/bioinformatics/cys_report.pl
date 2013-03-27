#!/usr/bin/perl
# Daniel Packer <dp@danielpacker.org>
# generate report on cysteine frameworks from fasta file

use strict;
use warnings;
use Bio::SeqIO;
use File::Basename qw(basename);
use Data::Dumper;
use Getopt::Long;
use lib '.';
use cysfw;
$|=1; # logging not buffered

##############################################################################
# subroutines
sub timestamp
{
  return POSIX::strftime("%Y-%m-%d %H:%M:%S ", localtime);
}


sub main
{

  my $output = "cys_report.txt";
  my $delim = "\t";
  my $header = 1;
  my $res = GetOptions(
    'output=s' => \$output,
    'delim=s' => \$delim,
    'header=i' => \$header
    );

  my $usage = "Usage: cys_report.pl [--output <file>] <file> ...";
  die $usage unless scalar(@ARGV);

  my ($total_sfams, $total_fws, $total_seqs);
  my (%track_fws, %track_sfams);
  
  open my $OFH, ">$output" or die "Couldn't open output file $output\n";

  print timestamp(), "cys_report.pl starting\n";
  my $count=0;
  for my $fn (@ARGV)
  {
    die "File $fn not found." unless (-e $fn);
    my $in  = Bio::SeqIO->new(-file => $fn, '-format' => 'Fasta');

    print $OFH "SEQUENCE${delim}FRAMEWORKS${delim}SUPERFAMILIES\n" if ($header);
    while (my $seq = $in->next_seq()) 
    {
      my $ss = $seq->seq();
      my ($fws_ref, $sfams_ref) = @{ cysfw::check_seq($ss) };

      # track the fws and sfams found
      for my $fw (@$fws_ref)
      {
        $track_fws{$fw}++;
        $total_fws++;
      }
      for my $sfam (@$sfams_ref)
      {
        $track_sfams{$sfam}++;
        $total_sfams++;
      }
      $total_seqs++;

      next unless (scalar(@$fws_ref));
      print $OFH join($delim, ($ss, join(',',@$fws_ref), join(',',@$sfams_ref))), "\n";
    }
  }
  close $OFH;
  
  # report distribution
  print "Frameworks distribution (proportion of $total_seqs sequences):\n";
  my %fws = cysfw::get_fws();
  for my $fw (sort keys %fws)
  {
    print "$fw\t", ($track_fws{$fw} || 0)/$total_seqs, "\n";
  }

# report distribution
  print "Superfamilies distribution (proportion of $total_seqs sequences):\n";
  my %sfams = cysfw::get_sfams();
  for my $sfam (sort keys %sfams)
  {
    print "$sfam\t", ($track_sfams{$sfam} || 0)/$total_seqs, "\n";
  }


  print timestamp(), "cys_report.pl finished running\n";
}

##############################################################################
# run
{
  main();
  exit(0);
}
