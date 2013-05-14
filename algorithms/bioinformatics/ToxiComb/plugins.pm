package plugins;

use strict;
use warnings;

sub process_sequence(@)
{
  my %args = @_;
  my $seq = $args{'sequence'} or die "no sequence";
  my $plugin = $args{'plugin'} or die "no plugin";

  if ($plugin eq 'conoprec')
  {
    return do_conoprec(%args);
  }
  else
  {
    die "Unknown plugin $plugin";
  }
}

# return hash of results from conoprec
sub do_conoprec($)
{
  my %args = @_;
  my $seq = $args{'sequence'} or die "no sequence";
  my $conoprec_path = $args{'path'} or die "no path";
  #use Data::Dumper; print Dumper \%args;
  my $command = $conoprec_path . " $seq";
  my $output = qx/$command/;

  #print "OUTPUT $output\n";

  my %conoprec_vals = ();

  my $string = $output;
  $string =~ /^SIG\s+(\d+)\s+(\d+)\s+(\w+).*/mg;
  if (defined $1 && defined $2)
  {
    $conoprec_vals{'conoprec_signalp_start'} = $1;
    $conoprec_vals{'conoprec_signalp_end'} = $2;
    $conoprec_vals{'conoprec_signalp'} = $3 || undef;
  }
  $string = $output;
  $string =~ /^PRE\s+(\d+)\s+(\d+)\s+(\w+).*/mg;
  if (defined $1 && defined $2)
  {
    $conoprec_vals{'conoprec_pre_start'} = $1;
    $conoprec_vals{'conoprec_pre_end'} = $2;
    $conoprec_vals{'conoprec_pre'} = $3 || undef;
  }
  $string = $output;
  $string =~ /^POS\s+(\d+)\s+(\d+)\s+(\w+).*/mg;
  if (defined $1 && defined $2)
  {
    $conoprec_vals{'conoprec_pos_start'} = $1;
    $conoprec_vals{'conoprec_pos_end'} = $2;
    $conoprec_vals{'conoprec_pos'} = $3 || undef;
  }
  $string = $output;
  $string =~ /^MAT\s+(\d+)\s+(\d+)\s+(\w+).*$/mg;
  if (defined $1 && defined $2 && defined $3)
  {
    $conoprec_vals{'conoprec_mature_start'} = $1;
    $conoprec_vals{'conoprec_mature_end'} = $2;
    $conoprec_vals{'conoprec_mature'} = $3;
  }
  return %conoprec_vals;
}

1;
