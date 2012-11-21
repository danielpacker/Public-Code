#!/usr/bin/perl
# Monty Hall game
# Author: Daniel Packer <dp@danielpacker.org>

use strict;
use warnings;

package montyOO;

sub new {
  my $pkg = shift;
  my $self = {
    'doors'         => [1..3], # 3 doors
    'first_choice'  => undef,
    'final_choice'  => undef,
    'revealed_door' => undef,
    'winner_door'   => undef,
    };
  bless $self, $pkg;
  return $self
}

sub run {
  my $self = shift;
  $self->set_winner();
  $self->first_choice();
  $self->reveal_door();
  $self->final_choice();
  return $self->game_result();
}

sub set_winner {
  my $self = shift;

  # set winning door
  my $winner_door = int(rand(3))+1; # {1,2,3}
  $self->{'winner_door'} = $winner_door;
}

sub first_choice {
  my $self = shift;
  # make first choice
  my $choice = int(rand(3))+1; # {1,2,3}
  $self->{'first_choice'} = $choice;
}

sub reveal_door {
  my $self = shift;
  # Now we reveal a door that isn't a winner and isn't what we chose
  my @loser_doors = grep { 
    $_ != $self->{'first_choice'}
    } @{ $self->{doors} };
  @loser_doors = grep { 
    $_ != $self->{'winner_door'}
    } @loser_doors;

  my $rand_loser_index = int(rand(scalar(@loser_doors))); # {0..size-1}
  my $rand_loser = $loser_doors[$rand_loser_index];
  $self->{'revealed_door'} = $rand_loser;
}

sub final_choice {
  my $self = shift;
  # Door remaining is...
  my ($door_remaining) = grep { 
    ($_ != $self->{'revealed_door'}) && ($_ != $self->{'first_choice'}) 
    } @{ $self->{'doors'} };

  # Flip a 1/0 coin. 1 we switch, 0 we don't.
  $self->{'final_choice'} = int(rand(2)) ? 
    $door_remaining : $self->{'first_choice'};
}

sub game_result {
  my $self = shift;
  return ($self->{'final_choice'} == $self->{'winner_door'}) ? 1 : 0;
}

1;
