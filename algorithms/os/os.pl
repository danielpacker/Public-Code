#!/usr/bin/perl -w
#
# A program and objects that simulate an operating system




use strict;
use warnings;

##############################################################################
# 
# DQ object (device queue entry)

package DQ;
sub new($$) {
  my $class = shift;
  my %args = @_;

  my $self = {};
  for my $arg (qw/pcb filename start_loc mode/)
  {
    if (not exists $args{$arg})
    {
      die "missing param $arg";
    }
    else
    {
      $self->{$arg} = $args{$arg};
    }
  }

  bless $self, $class;
  return $self;
}

sub dump() {
  my $self = shift;
}




##############################################################################
# 
# DEV object

package DEV;
sub new($$) {
  my $class = shift;
  my $id = shift or die "no id";

  my $self = {
    'id' => $id,
    'queue' => [],
  };
  bless $self, $class;
  return $self;
}

sub dump() {
  my $self = shift;
  print "=== Printer ID: ", $self->{'id'}, " ===\n";
  if (scalar @{$self->{'queue'}})
  {
    print " Contents of printer queue:\n";
    #use Data::Dumper; print Dumper $self;
    for my $dq (@{ $self->{'queue'} })
    {
      my $pcb = $dq->{'pcb'} or die "no pcb association found.";
      print "  Process ID: ", $pcb->{'pid'}, "\n";
      print "  Filename: ", $dq->{'filename'}, "\n";
      print "  Starting location: ", $dq->{'start_loc'}, "\n";
      print "  Mode (r/w): ", $dq->{'mode'}, "\n";
      print "\n";
    }
  }
}


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

sub dump() {
  my $self = shift;
  print $self->{'pid'}, "\n";
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
  "printer" => 0, "disk" => 0, "CD/RW" => 0, "CPU" => 1
  };
use constant MAX_DEVS_PER_TYPE => 255; # max 255 of any one device

##############################################################################
# Define reusable data structures
#

# Initialize queues for devices. These empty arrays will be used as queues.
# In perl arrays can act as simple FIFO queues with unshift() and pop()
my $DEVICES = {}; 
for my $type (keys %{ DEV_TYPES() })
{
  $DEVICES->{$type} = {};
}
my @READY_QUEUE = ();
my $PROCESS_COUNT = 1; # pid value increments with each new process
my $CPU_PCB = undef; # reference to PCB being worked on


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
      $DEVICES->{$dev_type}->{$dev_type . $dev_num} = 
        DEV->new(lc($dev_type) . $dev_num);
    }
  }

  use Data::Dumper;
  print Dumper $DEVICES;
}

sub code2type($) {
  my $code = shift or die "no code";
  my $type = undef;

  if (($code eq 'D') or ($code eq 'd'))
  {
    $type = "disk";
  }
  elsif (($code eq 'C') or ($code eq 'c'))
  {
    $type = "CD/RW";
  }
  elsif (($code eq 'P') or ($code eq 'p'))
  {
    $type = "printer";
  }
  return $type;
}

sub dev_queue($$$) {
  my $pcb = shift or die "no pcb";
  my $code = shift or die "no code";
  my $num = shift or die "no num";

  my $type = code2type($code) or die "invalid code";

  if (exists $DEVICES->{$type}->{"$type$num"})
  {
    print "Device valid. Issuing IO request.\n";
    print "Enter filename: ";
    my $filename = <STDIN>; chomp($filename);

    print "Enter starting location: ";
    my $start_loc = <STDIN>; chomp($start_loc);

    print "Enter mode (r or w): ";
    my $mode = <STDIN>; chomp($mode);

    my $dq = DQ->new(pcb => $pcb, filename => $filename, start_loc => $start_loc, mode => $mode);
    push @{ $DEVICES->{$type}->{"$type$num"}->{queue} }, $dq;
  }
}

sub dev_dequeue($$$) {
  my $pcb = shift or die "no pcb";
  my $code = shift or die "no code";
  my $num = shift or die "no num";

  my $type = code2type($code) or die "invalid code";

  if (exists $DEVICES->{$type}->{"$type$num"}->{'queue'}) # valid device
  {
    print "De-queueing item in device queue for $type$num\n";
    shift @{ $DEVICES->{$type}->{"$type$num"}->{'queue'} };
  }
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
      if ($CPU_PCB)
      {
        push @READY_QUEUE, $pcb;
      }
      else
      {
        $CPU_PCB = $pcb;
      }
    }

    elsif (($cmd eq 'T') or ($cmd eq 't'))
    {
      if ($CPU_PCB)
      {
        print "Process terminating.\n";
        $CPU_PCB = undef;
      }
      else
      {
        print "No current process.\n";
      }

      if (scalar @READY_QUEUE) # are there any pcb's left waiting?
      {
        $CPU_PCB = shift @READY_QUEUE; # first on list
        print "Switching to process ", $CPU_PCB->{'pid'}, "\n";
      }
        
    }

    elsif (($cmd eq 'S') or ($cmd eq 's'))
    {
      print "Snapshot mode. Available subcommands: \"r\", \"p\"\n";
      my $subcmd = <STDIN>;
      chomp($subcmd);

      if ($subcmd eq 'r')
      {
        print "Processes in the ready queue:\n";
        for my $pcb (sort { $a->{'pid'} <=> $b->{'pid'} } @READY_QUEUE) {
          $pcb->dump();
        }
      }
      elsif ($subcmd eq 'p')
      {
        print "Printer Process Info:\n";
        for my $printer_id (keys %{ $DEVICES->{'printer'} })
        {
          my $printer = $DEVICES->{'printer'}->{$printer_id};
          $printer->dump();
        }
      }
      else
      {
        print "Subcommand not recongnized. Returning to run mode.\n";
      }
    }

    elsif ($cmd =~ /^([pcd])(\d)$/)
    {
      if ($CPU_PCB)
      {
        print "Device request.\n";
        dev_queue($CPU_PCB, $1, $2);
      }
      else
      {
        print "No current process.\n";
      }
    }

    elsif ($cmd =~ /^([PCD])(\d)$/)
    {
      if ($CPU_PCB)
      {
        print "Completion interrupt.\n";
        dev_dequeue($CPU_PCB, $1, $2);
      }
      else
      {
        print "No current process.\n";
      }
    }

    else
    {
      print "INVALID COMMAND: $cmd\n";
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

