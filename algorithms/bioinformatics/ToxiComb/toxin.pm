# toxin object for ToxiComb

package toxin;

use strict;
use warnings;

# default properties for object
my %default_properties = (
  'id' => undef,
  'sequence' => undef,
  'mature_seq' => undef,
  'signalp_score' => undef,
  'signalp_seq' => undef,
  'signalp_start' => undef,
  'signalp_end' => undef,
  'frameworks' => undef,
  'conoprec_mature_seq' => undef,
  'conoprec_mature_start' => undef,
  'conoprec_mature_end' => undef,
);

sub new()
{
  my $class = shift;
  my %args = @_;
  my $self = { %default_properties };        # get default vals
  map { $self->{$_} = $args{$_} } keys %$self; # override defaults
  bless $self, $class;

  # if mature_seq not set, see if signalp_start is available
  $self->signalp_start($args{'signalp_start'});

  return $self;
}

sub id()
{
  my $self = shift;
  my $id = shift;
  $self->{'id'} = $id if ($id);
  return $self->{'id'};
}

sub signalp_score()
{
  my $self = shift;
  my $score = shift;
  $self->{'signalp_score'} = $score if ($score);
  return $self->{'signalp_score'};
}

sub signalp_seq()
{
  my $self = shift;
   my $seq = shift;
  $self->{'signalp_seq'} = $seq if ($seq);
  return $self->{'signalp_seq'};
}

sub signalp_start()
{
  my $self = shift;
  my $start = shift;

  if ($start)
  {
    $self->{'signalp_start'} = $start;
    
    # use signalp_start to get mature peptide
    $self->{'mature_seq'} = substr($self->{'sequence'}, $start-1);
  }

  return $self->{'signalp_start'};
}

sub signalp_end()
{
  my $self = shift;
  my $end = shift;
  $self->{'signalp_end'} = $end if ($end);
  return $self->{'signalp_end'};
}

sub conoprec_mature_start()
{
  my $self = shift;
  my $start = shift;
  $self->{'conoprec_mature_start'} = $start if ($start);
  return $self->{'conoprec_mature_start'};
}


sub conoprec_mature_end()
{
  my $self = shift;
  my $end = shift;
  $self->{'conoprec_mature_end'} = $end if ($end);
  return $self->{'conoprec_mature_end'};
}


sub sequence()
{
  my $self = shift;
  my $seq = shift;
  $self->{'sequence'} = $seq if ($seq);
  return $self->{'sequence'};
}

sub mature_seq()
{
  my $self = shift;
  my $seq = shift;
  $self->{'mature_seq'} = $seq if ($seq);
  return $self->{'mature_seq'};
}

sub conoprec_mature_seq()
{
  my $self = shift;
  my $seq = shift;
  $self->{'conoprec_mature_seq'} = $seq if ($seq);
  return $self->{'conoprec_mature_seq'};
}

sub frameworks()
{
  my $self = shift;
  my @fws = @_;
  #print "FRAMEWORKS: @fws\n";
  $self->{'frameworks'} = [@fws] if (scalar @fws);
  return $self->{'frameworks'};
}

# determine if all required fields are set
# currently only require id and sequence
sub validate()
{
  my $self = shift;
  if ($self->id() && $self->sequence() && $self->mature_seq())
  {
    return 1;
  }
  else
  {
    use Data::Dumper; print "INVALID: ", Dumper $self;
    return 0;
  }
}



1;
