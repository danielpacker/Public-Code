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
  my $command = $conoprec_path . " $seq";
  my $output = qx/$command/;

  $output =~ /^MAT\s+(\d+)\s+(\d+)\s+(\w+).*$/mg;
  return (
    'conoprec_start' => $1, 
    'conoprec_end' => $2, 
    'conoprec_mature' => $3
  ) if ($1 && $2 && $3);
}

1;
