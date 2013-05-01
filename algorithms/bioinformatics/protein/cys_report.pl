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
use lib '..';
use cysfw;
use formats::fasta_utils;
$|=1; # logging not buffered

use constant DEFAULT_SP_MINVALUE => "0.85";

##############################################################################
# subroutines
sub timestamp
{
  return POSIX::strftime("%Y-%m-%d %H:%M:%S ", localtime);
}


sub main
{

  my $output = "cys_report.txt"; # report name
  my $delim = "\t"; # delimiter to use in report output
  my $header = 1;   # show header in report output
  my $spfile;  # signalp file (optional)
  my $spminvalue = DEFAULT_SP_MINVALUE;
  my $res = GetOptions(
    'output=s' => \$output,
    'delim=s' => \$delim,
    'header=i' => \$header,
    'spfile' => \$spfile,
    'spmin'  => \$spminvalue,
    );

  my $usage = 'Usage: cys_report.pl [--output <file>] [--delim \t] [--header 1] [--spfile <file>] [--spmin #.## ] fasta_file ...';
  unless (scalar(@ARGV)) { print $usage, "\n"; exit(1) }

  # Collect sequence names from signalp output file if provided
  my %spseqs;
  if (defined $spfile)
  {
    open my $spf, "<$spfile" or die "Couldn't open file $spfile: $!";
    my @lines = <$spf>;
    close $spf or die $!;
    for my $line (@lines)
    {
      my @cols = split($line);
      $spseqs{$cols[0]}++ if ($cols[7] > $spminvalue);
    }
  }

  my ($total_sfams, $total_fws, $total_seqs) = (0,0,0);
  my (%track_fws, %track_sfams);
  
  open my $OFH, ">$output" or die "Couldn't open output file $output\n";

  print timestamp(), "cys_report.pl starting\n";
  for my $fn (@ARGV)
  {
    die "File $fn not found." unless (-e $fn);
    my $in  = Bio::SeqIO->new(-file => $fn, '-format' => 'Fasta');

    my $guessed_num_seqs = fasta_utils::guess_num_seqs($fn);
    print timestamp(), "Analyzing ~ $guessed_num_seqs sequences...\n";

    #print "Progress: [0%]";
    my $breakdown = 10;
    my $batchsize = $guessed_num_seqs/$breakdown;
    my $progress = 0;
    my $count = 0;

    print $OFH "SEQUENCE${delim}FRAMEWORKS${delim}SUPERFAMILIES\n" if ($header);

    while (my $seq = $in->next_seq()) 
    {
      my $ss = $seq->seq();
      my ($fws_ref, $sfams_ref) = @{ cysfw::check_seq('seq' => $ss) };

      # Display a progress bar (useful for large files)
      $progress = ($count/$batchsize)*$breakdown;
      my $progress_rounded = POSIX::ceil(($total_seqs/$batchsize)*$breakdown);
      print "[", $progress_rounded, "%] "
                    if (($batchsize > 1) && ($count % $batchsize == 0));
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
      $count++; 

      next unless (scalar(@$fws_ref));
      print $OFH join($delim, ($ss, join(',',@$fws_ref), join(',',@$sfams_ref))), "\n";
    }
    print " [100%]" if ($progress < 100);
    print "\n";
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
