#!/bin/perl -w
# Daniel Packer <dp@danielpacker.org>
# utility class to test sequences for cystein framework patterns
# cysteine framework data from:
# http://www.conoserver.org/?page=classification&type=cysteineframeworks

use strict;
use warnings;

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

use Data::Dumper;
print Dumper \%fwpatterns;

my %seq_patterns = (
  # SEQ => PATTERN TYPE
);

# Return list of frameworks a sequence belongs to
sub test_seq
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

#my $seq = "CDANIELCDANIELCDANIELCCDANIELCDANIEL";
#my @fw = test_seq($seq);
#print Dumper \@fw;

1;
