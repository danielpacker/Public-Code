#!/usr/bin/perl
# Monty Hall game
# Author: Daniel Packer <dp@danielpacker.org>

use strict;
use warnings;

my %doors = (1 => 0,
             2 => 0, 
             3 => 0);

# Put $100 behind a door:
my $winner_door = int(rand(3))+1; # {1,2,3}
$doors{$winner_door} = 1;

print "\n=== Welcome to the Monty Hall game where looks are deceiving! ===\n";

print "\nChoose from doors ", join(', ', sort keys %doors), ": ";

my $door_choice = 0;
while (! $door_choice =~ /^[123]$/) {
  $door_choice = <STDIN>; chomp $door_choice;
}

# Now we reveal a door that isn't a winner and isn't what we chose
my @loser_doors = grep { $_         != $door_choice } keys %doors;
   @loser_doors = grep { $doors{$_} != 1            } @loser_doors;

my $rand_loser_index = int(rand(scalar(@loser_doors))); # {0..size-1}
my $rand_loser = $loser_doors[$rand_loser_index];

print "\nDoor #$rand_loser is revealed! No money behind that door.\n";

# Door remaining is...
my ($door_remaining) = grep { 
  ($_ != $rand_loser) && ($_ != $door_choice) 
  } keys %doors;

print "\nKeep your choice of door #$door_choice, or switch to door #$door_remaining?\n";

my $switch_choice = '--default--';
while ($switch_choice ne '' && $switch_choice ne 's')
{
  print "(ENTER to keep choice, 's' to switch)\n";
  $switch_choice = <STDIN>; chomp $switch_choice;
}

# Switch choice if need be
$door_choice = ($switch_choice) ? $door_remaining : $door_choice;

my $result = ($winner_door == $door_choice) ? 'won' : 'lost';

print "You $result! The money was behind door #$winner_door.\n";
