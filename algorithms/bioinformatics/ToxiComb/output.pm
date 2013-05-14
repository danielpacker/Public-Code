# output module for ToxiComb

package output;

use strict;
use warnings;


# saves data to file
# expects format (e.g. fasta, xml), filename, arrayref of toxin objects
sub save(@)
{
  my %args = @_;

  #use Data::Dumper; print Dumper \%args;

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
    #use Data::Dumper; print Dumper $tox;
    die "Invalid toxin" unless $tox->validate();
    my $fws = $tox->frameworks;
    #use Data::Dumper; print "TOX: ", Dumper $fws;
    my $mature_seq = $tox->conoprec_signalp() ? $tox->conoprec_mature_seq() : $tox->mature_seq();
    print $FASTA 
      ">", $tox->id(),
      " | Frameworks: ", join(',', @$fws),
      " | SignalP Sequence: ", $tox->signalp_seq(),
      " | SignalP D Score: ", $tox->signalp_score(),
      " | SignalP Cleavage Start: ", $tox->signalp_start(),
      " | SignalP Sequence End: ", $tox->signalp_end(), 
      " | Conoprec Mature Start: ", $tox->conoprec_mature_start(), 
      " | Conoprec Mature End: ", $tox->conoprec_mature_end(),
      " | Conoprec PRE Start: ", $tox->conoprec_pre_start(), 
      " | Conoprec PRE End: ", $tox->conoprec_pre_end(), 
      " | Conoprec PRE Sequence: ", $tox->conoprec_pre(),
      " | Conoprec POS Start: ", $tox->conoprec_pos_start(), 
      " | Conoprec POS End: ", $tox->conoprec_pos_end(), 
      " | Conoprec POS Sequence: ", $tox->conoprec_pos(),
      " | Conoprec SignalP Start: ", $tox->conoprec_signalp_start(), 
      " | Conoprec SignalP End: ", $tox->conoprec_signalp_end(), 
      " | Conoprec SignalP Sequence: ", $tox->conoprec_signalp(), "\n";
    print $FASTA $mature_seq, "\n";
  }

  close $FASTA or die "Error closing $file: $!";
}

1;
