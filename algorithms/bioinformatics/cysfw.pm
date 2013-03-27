#!/bin/perl -w
# Daniel Packer <dp@danielpacker.org>
# utility class to test sequences for cystein framework patterns in sea snails
# cysteine framework data from the following URLs:
# http://www.conoserver.org/?page=classification&type=cysteineframeworks
# http://www.conoserver.org/?page=about_conotoxins&bpage=cononames

package cysfw;

use strict;
use warnings;

my %superfamilies = (
'A' => 'I,II,IV,XIV',
'B' => '',
'C' => '',
'D' => 'XX,XV',
'Divergent M---L-LTVA' => 'XIV,IX,VI/VII',
'Divergent MKFPLLFISL' =>  'VI/VII',
'Divergent MKLCVVIVLL' => 'XIV',
'Divergent MKLLLTLLLG' => '',
'Divergent MKVAVVLLVS' => '',
'Divergent MRCLSIFVLL' => 'XVI',
'Divergent MRFLHFLIVA' => 'VI/VII',
'Divergent MRFYIGLMAA' => 'V,I',
'Divergent MSKLVILAVL' => 'IX',
'Divergent MSTLGMTLL-' => 'XIX,XXII,IX',
'Divergent MTAKATLLVL' => 'XIV',
'Divergent MTFLLLLVSV' => 'IX',
'Divergent MTLTFLLVVA' => 'VI/VII',
'I1' => ' XI,VI/VII',
'I2' => ' XII,XI',
'I3' => ' XI,VI/VII',
'J' => 'XIV',
'K' => 'XXIII',
'L' => 'XIV',
'M' => 'IV,III,XVI,VI/VII,IX,I,XIV,II',
'O1' => ' XII,VI/VII,I,XIV',
'O2' => ' VI/VII,XV',
'O3' => ' VI/VII',
'P' => 'IX',
'S' => 'VIII',
'T' => 'X,V,XVI,I',
'V' => 'XV',
'Y' => 'XVII',
);

my %frameworks = (
'I' => 'CC-C-C',
'II' => 'CCC-C-C-C',
'III' => 'CC-C-C-CC',
'IV' => 'CC-C-C-C-C',
'V' => 'CC-CC',
'VI/VII' => 'C-C-CC-C-C',
'VIII' => 'C-C-C-C-C-C-C-C-C-C',
'IX' => 'C-C-C-C-C-C',
'X' => 'CC-C.[PO]C',
'XI' => 'C-C-CC-CC-C-C',
'XII' => 'C-C-C-C-CC-C-C',
'XIII' => 'C-C-C-CC-C-C-C',
'XIV' => 'C-C-C-C',
'XV' => 'C-C-CC-C-C-C-C',
'XVI' => 'C-C-CC',
'XVII' => 'C-C-CC-C-CC-C',
'XVIII' => 'C-C-CC-CC',
'XIX' => 'C-C-C-CCC-C-C-C-C',
'XX' => 'C-CC-C-CC-C-C-C-C',
'XXI' => 'CC-C-C-C-CC-C-C-C',
'XXII' => 'C-C-C-C-C-C-C-C',
'XXIII' => 'C-C-C-CC-C',
);

my %fwpatterns = ();
for my $type (keys %frameworks)
{
  my $patt = $frameworks{$type};
  $patt =~ s/-/[^C]*/g;
  $fwpatterns{$type} = $patt;
}

#use Data::Dumper;
#print Dumper \%fwpatterns;

my %seq_patterns = (
  # SEQ => PATTERN TYPE
);

# Return list of frameworks a sequence belongs to
sub check_frameworks
{
  my $seq = shift;
  my @frameworks = ();
  for my $type (keys %fwpatterns)
  {
    my $patt = $fwpatterns{$type};
    push(@frameworks, $type) if ($seq =~ /$patt/);
  }
  return @frameworks;
}

sub check_super_fams($)
{
  my $patt = shift;
  my @sfams = ();
  for my $fam (keys %superfamilies)
  {
    for(split(',', $superfamilies{$fam}))
    {
      push(@sfams, $fam) if ($patt eq $_);
    }
  }
  return @sfams;
}

sub check_seq($)
{
  my $seq = shift;
  my (@sfams, @fws);
  for my $fw (check_frameworks($seq))
  {
    push @fws, $fw;
    for my $sf (check_super_fams($fw))
    {
      push @sfams, $sf;
    }
  }
  return [ [@fws], [@sfams] ];
}


sub show_check_seq($)
{
  my $seq = shift;
  my ($fws_ref, $sfams_ref) = @{ check_seq($seq) };
  print "Sequence: $seq\n";
  print "Frameworks: ", join(", ", @$fws_ref), "\n";
  print "Super-families: ", join(", ", @$sfams_ref), "\n";
}

sub test()
{
  my $seq = "CDANIELCDANIELCDANIELCCDANIELCDANIEL";
  show_check_seq($seq);
}


1;
