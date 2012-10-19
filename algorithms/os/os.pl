#!/usr/bin/perl -w
#
# A program and objects that simulate an operating system




use strict;
use warnings;




##############################################################################
# 
# PCB object

package PCB;
sub new($$) {
  my $class = shift;
  my $pid = shift or die "no pid";

  my $self = {
    'registers' => [],
    'stack' => [],
    'pid' => $pid,
  };
  bless $self, $class;
  return $self;
}


package main; #default package namespace

##############################################################################
# Define program constants
#
use constant SG_BANNER => "\n[================= SYS GEN ==================]\n\n";
use constant SG_STR2 => "Specify the number of devices of each type:\n";
use constant SG_STR3 => "Select a device type to generate or ENTER to run: ";
use constant SG_STR4 => "Enter number of devices: ";
use constant SG_STR5 => "Devices updated.\n";
use constant SG_STR6 => "Press ENTER without input to proceed with running.\n";
use constant SG_MAXERR => "ERROR: Value exceeds the maximum number of devices.\n";
use constant SG_CPUERR => "ERROR: You must have at least 1 active CPU.\n";
use constant RUN_BANNER => "\n[================= RUNNING ==================]\n\n";
use constant RUN_PROMPT => "Enter Command> ";
use constant RUN_CMDERR => "ERROR: Invalid command.\n";

use constant DEV_TYPES => { # number refers to qty. 0 is ulimited (to max)
  "Printer" => 0, "Disk" => 0, "CD/RW" => 0, "CPU" => 1
  };
use constant MAX_DEVS_PER_TYPE => 255; # max 255 of any one device

##############################################################################
# Define reusable data structures
#

# Initialize queues for devices. These empty arrays will be used as queues.
# In perl arrays can act as simple FIFO queues with unshift() and pop()
my $DEVICES = {}; 
my $DEV_QUEUES  = {};
for my $type (keys %{ DEV_TYPES() })
{
  $DEVICES->{$type} = [];
  $DEV_QUEUES->{$type} = [];
}
my $READY_QUEUE = [];
my $PROCESS_COUNT = 1; # pid value increments with each new process


##############################################################################
# Program subroutines
#

sub sys_gen() {

  my $do_gen=1;
  my $devs_to_create = { %{ DEV_TYPES() } };
  my @dev_types_names = keys %$devs_to_create;

  while ($do_gen) 
  {
    print SG_BANNER, SG_STR2;
    my $dev_pos=1;
    for my $type (@dev_types_names)
    {
      my $max = DEV_TYPES()->{$type};
      $max = MAX_DEVS_PER_TYPE if ($max == 0);
      my $current_num_devs = $devs_to_create->{$type};
      print $dev_pos++, " ", $type, " ", "(max $max, currently $current_num_devs)", "\n";
    }
    print "\n", SG_STR3;
    my $selection = <STDIN>;
    chomp($selection);

    if (length($selection) > 0)
    {
      my $dev_type_name = $dev_types_names[$selection-1];
      print "\n", "Enter number of $dev_type_name devices: ";
      my $num_devices = <STDIN>;
      chomp($num_devices);
      if (length($num_devices) > 0)
      {
        my $max_num_devices = DEV_TYPES()->{$dev_type_name} || MAX_DEVS_PER_TYPE;
        if ($num_devices > $max_num_devices) 
        {
          print SG_MAXERR;
        }
        else
        {
          $devs_to_create->{$dev_type_name} = $num_devices;
        }
        next;
      }
    } 
    else 
    {
      if ($devs_to_create->{'CPU'} == 0)
      {
        print SG_CPUERR;
      }
      else
      {
        $do_gen=0;
      }
    }
    
  }
  return $devs_to_create;
 
}

# Init the DEVICES collection of devices based on sys_gen choices
sub create_devices($) {
  my $devs_to_create = shift or die "No device specification received\n";

  # Create the devices from the spec generated in sys gen
  while (my($dev_type,$num_devices) = each $devs_to_create)
  {
    my $suffix = ($num_devices > 1) ? "s" : "";
    print "Creating $num_devices $dev_type$suffix\n";
    for my $dev_num (0..$num_devices)
    {
      next if $dev_num == 0; # device numbering starts at 1
      push @{$DEVICES->{$dev_type}}, {
        'ID' => lc($dev_type) . $dev_num
        };
    }
  }

  use Data::Dumper;
  print Dumper $DEVICES;

}

# Interpret a run_mode command
sub interpret_command($) {
  my $cmd = shift or die "No command given";
  if (validate_command($cmd))
  {

  }
  else
  {
    print RUN_CMDERR;
    return 0;
  }
}

# Validate a run mode command
sub validate_command($) {
  my $cmd = shift or die "No command given";
  return 1;
}

# Run mode
sub run() {

  print RUN_BANNER;

  my $run = 1;

  while ($run)
  {
    print RUN_PROMPT;
    my $cmd = <STDIN>;
    chomp($cmd);

    if (($cmd eq 'A') or ($cmd eq 'a'))
    {
      print "Process arrived with pid $PROCESS_COUNT.\n";
      my $pcb = PCB->new($PROCESS_COUNT++);
    }

    elsif (($cmd eq 'T') or ($cmd eq 't'))
    {
      print "Process terminating.\n";
    }

    elsif (($cmd eq 'S') or ($cmd eq 's'))
    {
      print "Snapshot mode.\n";
      my $subcmd = <STDIN>;
      chomp($subcmd);

      if ($subcmd eq 'r')
      {
        print "Ready Queue Processes:\n";
      }
      elsif ($subcmd eq 'p')
      {
        print "Printer Process Info:\n";
      }
    }

    elsif ($cmd =~ /^([pcd])(\d)$/)
    {
      print "Device request.\n";
    }

    elsif ($cmd =~ /^([PCD])(\d)$/)
    {
      print "Completion interrupt.\n";
    }

    else
    {
      print "CMD NOT RECOGNIZED: $cmd\n";
    }


  }

  print RUN_BANNER;
}

##############################################################################
# Main subroutine and execution (program runs here)
#
sub main() {

  create_devices(sys_gen());
  run();
  exit(0);
}

main(); # start running

