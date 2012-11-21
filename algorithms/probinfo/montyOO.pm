#!/usr/bin/perl
# Monty Hall game
# Author: Daniel Packer <dp@danielpacker.org>

use strict;
use warnings;

package montyOO;

use Data::Dumper;

sub new {
  my $pkg = shift;
  my %params = @_;
  my $self = {
    'doors'          => {},    # key 0 default, key 1 revealed
    'first_choice'   => undef,
    'next_choice'   => undef,
    'winner_door'    => undef,
    'switch'         => 'rand',
    'num_doors'      => 3,
    'keep_picking'   => 1,
    'doors_revealed' => 0,      # efficient tracking
    'debug'          => 0,
    'visual'         => 0,
    'ouput'          => '',
    };

  # override defaults
  map { $self->{$_} = $params{$_} if exists $self->{$_}} keys %params;

  # create doors
  map { $self->{'doors'}->{$_} = 0} (1..$self->{'num_doors'});

  bless $self, $pkg;
  return $self
}

sub run {
  my $self = shift;
  $self->set_winner();
  $self->first_choice();
  $self->visual_snapshot() if ($self->{'visual'} == 1);

  # reveal all the doors and switch if desired
  # check num_doors-2 because at end we should have 1 revealed and 1 chosen
  while ($self->{'doors_revealed'} < $self->{'num_doors'}-2 )
  {
    $self->reveal_door();
    $self->next_choice();
    $self->visual_snapshot() if ($self->{'visual'} == 1);
  }
  # Now make a final choice between last 2 spots
  $self->next_choice();
  print Dumper $self if ($self->{'debug'} == 1);
  $self->visual_snapshot() if ($self->{'visual'} == 1);
  return $self->game_result();
}

sub set_winner {
  my $self = shift;

  # set winning door
  my $winner_door = int(rand($self->{'num_doors'}))+1; # {1,2,3}
  $self->{'winner_door'} = $winner_door;
}

sub first_choice {
  my $self = shift;
  # make first choice
  my $choice = int(rand($self->{'num_doors'}))+1; # {1,2,3}
  $self->{'first_choice'} = $choice;
  $self->{'next_choice'}  = $choice;
}

sub reveal_door {
  my $self = shift;
  # Now we reveal a door that isn't a winner and isn't what we chose
  my @loser_doors = grep { 
    ($_ != $self->{'first_choice'}) &&
    ($_ != $self->{'winner_door'}) &&
    ($self->{'doors'}->{$_} == 0)
    } keys %{ $self->{doors} };

  my $rand_loser_index = int(rand(scalar(@loser_doors))); # {0..size-1}
  my $rand_loser = $loser_doors[$rand_loser_index];
  $self->{'doors'}->{$rand_loser} = 1;
  $self->{'doors_revealed'}++;
}

sub next_choice {
  my $self = shift;
  # Door remaining is...
  my (@doors_remaining) = grep { 
    ($self->{'doors'}->{$_}  != 1) && 
    ($self->{'next_choice'} != $_) 
    } keys %{ $self->{'doors'} };
    #use Data::Dumper; print Dumper $self->{'doors'};
    #print "THERE ARE ", scalar(@doors_remaining), " doors remaining after first choice\n";
  my $door_remaining = $doors_remaining[ int(rand(scalar(@doors_remaining))) ];

  if ($self->{'switch'} eq 'rand')
  {
    # Flip a 1/0 coin. 1 we switch, 0 we don't.
    $self->{'next_choice'} = int(rand(2)) ? 
      $door_remaining : $self->{'first_choice'};
  }
  elsif ($self->{'switch'} eq 'true')
  {
    $self->{'next_choice'} = $door_remaining;
  }
  elsif ($self->{'switch'} eq 'last')
  {
    if ($self->{'doors_revealed'} == $self->{'num_doors'}-2 )
    {
      $self->{'next_choice'} = $door_remaining;
    }
  }
  else # switch == false
  {
    $self->{'next_choice'} = $self->{'first_choice'};
  }
}

sub game_result {
  my $self = shift;
  return ($self->{'next_choice'} == $self->{'winner_door'}) ? 1 : 0;
}

sub dump {
  my $self = shift;
  use Data::Dumper; print Dumper $self;
}

sub visual_snapshot {
  my $self = shift;

  my $output = "";
  for my $door (sort keys %{ $self->{'doors'} })
  {
    $output .= "[";
    if ($self->{'doors'}->{$door}==1)
    {
      $output .= "X";
    }
    else
    {
      if ($door == $self->{'next_choice'})
      {
        if ($door == $self->{'winner_door'})
        {
          $output .= "C";
        }
        else
        {
          $output .= "c";
        }
      }
      elsif ($door == $self->{'winner_door'})
      {
        $output .= "W";
      }
      else
      {
        $output .= " ";
      }
    }
    $output .= "]";
  }
  $output .= "\n";
  $self->{'output'} .= $output;
}

sub output {
  my $self = shift;
  return $self->{'output'};
}

1;
