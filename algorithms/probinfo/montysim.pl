#!/usr/bin/perl

use strict;
use warnings;

use lib '.';
use montyOO;


my $help = q/
*****************************************************************************
*                                                                           *
*    Monty Hall Simulator                                                   *
*    Author: Daniel Packer <dp@danielpacker.org>                            *
*                                                                           *
*    Usage: montysim.pl [switch=<true|false|rand>] [sims=<####>]            *
*                                                                           *
*    Options:                                                               *
*        switch: switch choice after a door is revealed? (default=rand)     *
*          sims: number of simulations to run (default=1)                   *
*                                                                           *
*****************************************************************************
/;

print "\n$help\n";

# Get options
my %cmd_params = (
  'switch' => 'rand',
  'sims'   => 10,
  );
my $cmd_str = join("|", keys %cmd_params);
my @command_args = grep { /^($cmd_str)=[A-Za-z0-9]+$/ } @ARGV;
map { my ($k,$v)=split("=", $_); $cmd_params{$k}=$v } @command_args;
#use Data::Dumper; print Dumper \%cmd_params;

## statistics ##
my $num_sims = $cmd_params{'sims'};
my $total_wins = 0;
my $mean_wins = 0;

# run some simulations
for my $run (1..$cmd_params{'sims'})
{
  my $MHS = montyOO->new();
  $total_wins++ if $MHS->run(); # tally wins
}
my $total_losses = $num_sims - $total_wins;
my $mean_wins = $total_wins / $num_sims;

my $output = qq/
=============================== STATISTICS =============================== 

     Number of sims:   $num_sims                                             
     Number of wins:   $total_wins                                          
     Number of losses: $total_losses                                          
     Mean win percent: $mean_wins                                          
/;
print $output, "\n";



