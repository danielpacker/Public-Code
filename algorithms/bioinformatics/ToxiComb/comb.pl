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
use toxin;
use output;
$|=1; # logging not buffered

use constant DEFAULT_SP_MINVALUE => "0.85";

##############################################################################
# subroutines
sub timestamp
{
  return POSIX::strftime("%Y-%m-%d %H:%M:%S ", localtime);
}

# takes a filename, returns hash of signalp records index by name
sub get_signalp_records($)
{
  my $spfile = shift or die "No signalp file provided";
  die "Signalp file $spfile not found" unless (-e $spfile);

  print "Reading signalp file $spfile...";

  # Collect sequence names from signalp output file if provided
  my %spseqs;
  if (defined $spfile)
  {
    open my $spf, "<$spfile" or die "Couldn't open file $spfile: $!";
    my @lines = <$spf>;
    close $spf or die $!;
    my $spcount=1;
    for my $line (@lines)
    {
      next if ($line =~ /^\s*#/);
      my @cols = split(/\s+/, $line);
      # below are signalp 4.1 column names for short output
      my @labels = qw/name Cmax pos1 Ymax pos2 Smax pos3 Smean D ? Dmaxcut Networks-used/;
      die "Invalid signalp record in file $spfile at line $spcount"
        if (scalar(@cols) != scalar(@labels)); # make sure we have a full column set
      my %record = map { $labels[$_] => $cols[$_] } (0..scalar(@cols)-1);
      $spseqs{$cols[0]} = { %record };
      $spcount++;
    }
  }
  print "done.\n";
  return \%spseqs;
}


sub main
{
  my $output = "toxicomb_report.txt"; # report name
  my $delim = "\t"; # delimiter to use in report output
  my $header = 1;   # show header in report output
  my $spfile;  # signalp file (optional)
  my $fasta; # output fasta to file
  my $spminvalue = DEFAULT_SP_MINVALUE;
  my $res = GetOptions(
    'output=s' => \$output,
    'delim=s' => \$delim,
    'header=i' => \$header,
    'spfile=s' => \$spfile,
    'spmin=s'  => \$spminvalue,
    'fasta=s' => \$fasta,
    );

  my $usage = 'Usage: comb.pl [--output <file>] [--delim \t] [--header 1] [--spfile <file>] [--spmin #.## ] [--fasta <file>] fasta_file ...';
  unless (scalar(@ARGV)) { print $usage, "\n"; exit(1) }

  my ($total_sfams, $total_fws, $total_seqs) = (0,0,0);
  my (%track_fws, %track_sfams, %track_sp);

  # store signalp records indexed by sequence name
  my %spseqs = (); 
  %spseqs = %{ get_signalp_records($spfile) } if ($spfile);
  
  # Start to generate report file
  open my $OFH, ">$output" or die "Couldn't open output file $output\n";

  my @toxins = (); # store all found putative toxins

  print timestamp(), "comb.pl starting\n";
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
      my $ss = $seq->seq() or die "No sequence in $fn at count $count";
      my $id = $seq->id() or die "No ID for sequence $ss in $fn at count $count";


      # Display a progress bar (useful for large files)
      $progress = ($count/$batchsize)*$breakdown;
      my $progress_rounded = POSIX::ceil(($total_seqs/$batchsize)*$breakdown);
      print "[", $progress_rounded, "%] "
                    if (($batchsize > 1) && ($count % $batchsize == 0));

      # Track signal p matches
      $track_sp{$id}++ if (exists $spseqs{$id} && $spseqs{$id} > 0);

      # get signalp record for this sequence if it exists
      my ($sprec, $signalp_start, $signalp_end, $signalp_score, $signalp_seq, $mature_seq);
      if ($sprec = $spseqs{$id})
      {
        $signalp_start = $sprec->{'pos1'} or die "bad pos1";
        $signalp_end = length($ss);
        $signalp_score = $sprec->{'D'} or die "bad D";
        $signalp_seq = substr($ss, 0, $signalp_start-1);
        $mature_seq = substr($ss, $signalp_start);
      }

      # track the fws and sfams found
      my $seq_to_check = $mature_seq || $ss;
      my ($fws_ref, $sfams_ref) = @{ cysfw::check_seq('seq' => $seq_to_check) };
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

      # create toxin records to pass to ouput
      my $tox = new toxin(
        'id' => $id,
        'sequence' => $ss,
        'mature_seq' => $mature_seq,
        'signalp_start' => $signalp_start,
        'signalp_end' => $signalp_end,
        'signalp_score' => $signalp_score,
        'signalp_seq' => $signalp_seq,
      );

      $tox->frameworks(@$fws_ref);

      next unless (scalar(@$fws_ref) && exists $spseqs{$id} && ($signalp_start < $signalp_end) && ($spseqs{$id}->{'?'} eq 'Y'));

      push @toxins, $tox;

      print $OFH join($delim, ($ss, join(',',@$fws_ref), join(',',@$sfams_ref))), "\n";

    }
    print " [100%]" if ($progress < 100);
    print "\n";
  }
  close $OFH;

  # output fasta if required
  if ($fasta)
  {
    output::save('filename' => $fasta, 'format' => 'fasta', 'toxins' => \@toxins)
  }
  
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


  print timestamp(), "comb.pl finished running\n";
}

##############################################################################
# run
{
  main();
  exit(0);
}
