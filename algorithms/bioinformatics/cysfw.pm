#!/bin/perl -w
# Daniel Packer <dp@danielpacker.org>
# utility class to test sequences for cystein framework patterns in sea snails
# cysteine framework data from the following URLs:
# http://www.conoserver.org/?page=classification&type=cysteineframeworks
# http://www.conoserver.org/?page=about_conotoxins&bpage=cononames

package cysfw;

use strict;
use warnings;
use Data::Dumper;
use Test::More;

use constant DEFAULT_MAX_CYS_GAP => 20; # 20 non cysteine's max

# Superfamilies and framework association from conoserver
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

sub get_sfams()
{
  return (%superfamilies);
}

# Framework patterns from conoserver
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

sub get_fws()
{
  return (%frameworks);
}

my %fwpatterns = (); # store the framework patterns
my $max_gap_gen = DEFAULT_MAX_CYS_GAP; # track what gap was used for last gen


# Turn the framework patterns into perl regular expressions.
# If a max cys gap is provided, override the default.
sub gen_fw_patterns
{
  my $max_cys_gap = shift || DEFAULT_MAX_CYS_GAP;
  for my $type (keys %frameworks)
  {
    my $patt = $frameworks{$type};
    $patt =~ s/-/[^C]{1,$max_cys_gap}/g; # dashes mean strings of non-C
    $fwpatterns{$type} = qr/$patt/; #store compiled regexp
  }
  $max_gap_gen = $max_cys_gap;
}
gen_fw_patterns(); # set up default patterns

# Return list of frameworks a sequence belongs to
sub check_frameworks($;$)
{
  my $seq = shift or die "no sequence";
  my $max_cys_gap = shift;
  if (defined $max_cys_gap && $max_cys_gap != $max_gap_gen)
  { # re-gen patterns using specific max gap if not already done
    gen_fw_patterns($max_cys_gap);
  }
  my @frameworks = ();
  for my $type (keys %fwpatterns)
  {
    my $patt = $fwpatterns{$type};
    push(@frameworks, $type) if ($seq =~ $patt); #pre-compiled regexp
  }
  return @frameworks;
}

# Probably not useful. Initial attempt to correlate superfamily.
# Superfamily is probably meaningless, however.
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

# Given a sequence and optionally a max cys gap check it
# to see what frameworks it belongs to and return the list.
# Also attempt to find superfamily but this is deprecated.
sub check_seq(%)
{
  my %args = @_;
  die "no sequence" unless defined $args{'seq'};
  my $max_cys_gap = $args{'max_cys_gap'} || DEFAULT_MAX_CYS_GAP;

  my (@sfams, @fws);
  for my $fw (check_frameworks($args{'seq'}, $max_cys_gap))
  {
    push @fws, $fw;
    for my $sf (check_super_fams($fw))
    {
      push @sfams, $sf;
    }
  }
  return [ [@fws], [@sfams] ];
}

# show information returned by check_seq
sub show_check_seq(%)
{
  my %args = @_;
  my ($fws_ref, $sfams_ref) = @{ check_seq(%args) };
  print "Sequence: $args{'seq'}\n";
  print "Frameworks: ", join(", ", @$fws_ref), "\n";
  #print "Super-families: ", join(", ", @$sfams_ref), "\n";
}

# check that a sequence has a given framework
sub seq_has_framework(%)
{
  my %args = @_;
  die "no seq" unless defined $args{'seq'};
  die "no framework" unless defined $args{'framework'};
  my ($fws_ref, $sfams_ref) = @{ check_seq(%args) };
  return grep { /$args{'framework'}/ } @$fws_ref;
}

# Test framework checker by generating a set of test sequences
# based on the patterns and running the frameowrk checker on each
# sequence to see if we retrieve the expected framework.
# Returns true for pass, false for fail
sub test()
{
  my %testseqs = map { $_ => $frameworks{$_} } (keys %frameworks);
  my $teststr = "DANIEL";

  # Start with a copy of frameworks and turn it into a series of
  # test sequences to check against expected framework matches
  for my $fw (keys %frameworks)
  {
    my $seq_orig = $testseqs{$fw};
    my $test_seq = $seq_orig;
    $test_seq =~ s/-/$teststr/g;
    $test_seq =~ /\[([^\]]*)\]/; # look for char classes
    if (defined $1) # if we find char class, substitute with any member
    {
      my $reduced_set = substr($1, 0, 1);
      $test_seq =~ s/\[([^\]]*)\]/$reduced_set/;
    }
    $test_seq = $teststr . $test_seq . $teststr;
    $testseqs{$fw} = $test_seq;
  }

  # Now that we have our test sequences, confirm they have the 
  # expected framework matches
  my @fails;
  for my $fw (keys %testseqs)
  {
    my $seq = $testseqs{$fw};
    unless (seq_has_framework('seq' => $seq, 'framework' => $fw))
    {
      push @fails, $fw; # record failure
    }
  }
  #print Dumper \%testseqs;
  #print "NUMBER OK $ok VS TOTAL ", scalar(keys %testseqs), "\n";
  warn "Framework tests failed: @fails\n" if scalar(@fails);
  return scalar(@fails) ? 0 : 1;
}


1;
