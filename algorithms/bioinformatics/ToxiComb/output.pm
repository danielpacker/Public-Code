# output module for ToxiComb

package output;

use strict;
use warnings;


# saves data to file
# expects format (e.g. fasta, xml), filename, arrayref of toxin objects
sub save(@)
{
  my %args = @_;

  use Data::Dumper; print Dumper \%args;

  die "Missing params" unless (
    $args{'format'} and $args{'filename'} and $args{'toxins'}
  );

  my $format = $args{'format'};
  my $filename = $args{'filename'};

  my @valid_formats = qw/fasta xml/;
  die "Invalid format" unless grep @valid_formats, $args{'format'};

  if ($format eq 'fasta')
  {
    save_fasta(%args);
  }
  elsif ($format eq 'xml')
  {
  }
}

# do fasta-specific save
sub save_fasta(@)
{
  my %args = @_;
  my $file = $args{'filename'};
  my @toxins = @{ $args{'toxins'} };

  open my $FASTA, ">", $file or die "Can't open $file: $!";

  # Print the header
  # >ID | Framework1, Framework2, etc | Signal Sequence | SignalP Score | SignalP cleavage start, end
  # MATURE SEQUENCE

  for my $tox (@toxins)
  {
  use Data::Dumper; print Dumper $tox;
    die "Invalid toxin" unless $tox->validate();
    print $FASTA 
      ">", $tox->id(),
      "|", join(',', $tox->frameworks()),
      "|", $tox->signalp_seq(),
      "|", $tox->signalp_score(),
      "|", $tox->signalp_start(),
      "|", $tox->signalp_end(), "\n";
    print $FASTA $tox->mature_seq(), "\n";
  }

  close $FASTA or die "Error closing $file: $!";
}

1;
