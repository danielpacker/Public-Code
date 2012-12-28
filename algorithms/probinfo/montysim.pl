#!/usr/bin/perl

use strict;
use warnings;

use lib '.';
use montyOO;

use Benchmark qw(:all);

use Data::Dumper;

my $help = q/
*****************************************************************************
*                                                                           *
*    Monty Hall Simulator                                                   *
*    Author: Daniel Packer <dp@danielpacker.org>                            *
*                                                                           *
*    Usage: montysim.pl [switch=<true|false|rand|last>] [sims=<####>]       *
*                                                                           *
*    Options:                                                               *
*        switch: switch choice after a door is revealed? (default=rand)     *
*                (random is random switching, last is switch only last)     *
*          sims: number of simulations to run (default=1)                   *
*        visual: display the status of each door at each step visually      *
*     num_doors: number of doors in simulation                              *
*                                                                           *
*****************************************************************************
/;

sub main {

  print "\n$help\n";

  # Get options
  my %cmd_params = (
    'switch'    => 'rand',
    'sims'      => 10,
    'num_doors' => 3,
    'debug'     => 0,
    'visual'    => 0,
    );
  my $cmd_str = join("|", keys %cmd_params);
  my @command_args = grep { /^($cmd_str)=[A-Za-z0-9]+$/ } @ARGV;
  map { my ($k,$v)=split("=", $_); $cmd_params{$k}=$v } @command_args;
  #use Data::Dumper; print Dumper \%cmd_params;

  ## statistics ##
  my $num_sims = $cmd_params{'sims'};
  my $total_wins   = 0;
  my $total_losses = 0;
  my $mean_wins    = 0;
  my $mean_losses  = 0;

  # run some simulations
  for my $run (1..$cmd_params{'sims'})
  {
    my $MHS = montyOO->new(%cmd_params);
    $total_wins++ if $MHS->run(); # tally wins
    print $MHS->output() if (exists $cmd_params{'visual'} && $cmd_params{'visual'} == 1);
    #print Dumper $MHS;
  }
  $total_losses = $num_sims - $total_wins;
  $mean_wins = ( $total_wins / $num_sims ) * 100.0;
  $mean_losses = 100 - $mean_wins;

  my $output = qq/
=============================== STATISTICS =============================== 

      Number of sims:    $num_sims                                         
      Number of wins:    $total_wins  
      Number of losses:  $total_losses
      Mean win percent:  $mean_wins 
      Mean loss percent: $mean_losses
  /;
  print $output, "\n";
}

{
  my $start = Time::HiRes::gettimeofday();
  main();
  my $end = Time::HiRes::gettimeofday();
  print "Simulation runtime (sec): ", sprintf("%.2f\n", $end - $start), "\n";
  exit(0);
}


