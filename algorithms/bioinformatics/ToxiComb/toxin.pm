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
  'conoprec_pos_start' => undef,
  'conoprec_pos_end' => undef,
  'conoprec_pos' => undef,
  'conoprec_pre_start' => undef,
  'conoprec_pre_end' => undef,
  'conoprec_pre' => undef,
  'conoprec_signalp_start' => undef,
  'conoprec_signalp_end' => undef,
  'conoprec_signalp' => undef,
);

sub new()
{
  my $class = shift;
  my %args = @_;
  my $self = { %default_properties };        # get default vals
  map { $self->{$_} = $args{$_} } keys %$self; # override defaults
  bless $self, $class;
  #use Data::Dumper; print Dumper $self;

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
    $self->{'mature_seq'} = substr($self->{'sequence'}, $start);
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

sub conoprec_pre()
{
  my $self = shift;
  my $in = shift;
  $self->{'conoprec_pre'} = $in if (defined $in);
  return $self->{'conoprec_pre'};
}

sub conoprec_pre_start()
{
  my $self = shift;
  my $in = shift;
  $self->{'conoprec_pre_start'} = $in if (defined $in);
  return $self->{'conoprec_pre_start'};
}

sub conoprec_pre_end()
{
  my $self = shift;
  my $in = shift;
  $self->{'conoprec_pre_end'} = $in if (defined $in);
  return $self->{'conoprec_pre_end'};
}

sub conoprec_pos()
{
  my $self = shift;
  my $in = shift;
  $self->{'conoprec_pos'} = $in if (defined $in);
  return $self->{'conoprec_pos'};
}

sub conoprec_pos_start()
{
  my $self = shift;
  my $in = shift;
  $self->{'conoprec_pos_start'} = $in if (defined $in);
  return $self->{'conoprec_pos_start'};
}

sub conoprec_pos_end()
{
  my $self = shift;
  my $in = shift;
  $self->{'conoprec_pos_end'} = $in if (defined $in);
  return $self->{'conoprec_pos_end'};
}


sub conoprec_signalp()
{
  my $self = shift;
  my $in = shift;
  $self->{'conoprec_signalp'} = $in if (defined $in);
  return $self->{'conoprec_signalp'};
}

sub conoprec_signalp_start()
{
  my $self = shift;
  my $in = shift;
  $self->{'conoprec_signalp_start'} = $in if (defined $in);
  return $self->{'conoprec_signalp_start'};
}

sub conoprec_signalp_end()
{
  my $self = shift;
  my $in = shift;
  $self->{'conoprec_signalp_end'} = $in if (defined $in);
  return $self->{'conoprec_signalp_end'};
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
