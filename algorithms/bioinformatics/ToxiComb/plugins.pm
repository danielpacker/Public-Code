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

  $output =~ /^MAT\s+(\d+)\s+(\d+)\s+(\w+).*$/mg;
  if (defined $1 && defined $2 && defined $3)
  {
    return (
      'conoprec_mature_start' => $1, 
      'conoprec_mature_end' => $2, 
      'conoprec_mature' => $3
    );
  }
  return ();
}

1;
