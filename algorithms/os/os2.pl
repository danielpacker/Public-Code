#!/usr/bin/perl -w
#
# A program and objects that simulates an operating system
# by Daniel Packer <dp@danielpacker.org>
#



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

sub dump($) {
  my $self = shift;
  my $no_header = shift or 0;
  #print "=== Printer ID: ", $self->{'id'}, " ===\n";
  print "\n", sprintf("%-15s%-15s%-15s%-20s%-10s", "DEVICE ID", "PROCESS ID", "FILENAME", "STARTING lOCATION", "MODE"), "\n" unless ($no_header);
  if (scalar @{$self->{'queue'}})
  {
    #use Data::Dumper; print Dumper $self;
    for my $dq (@{ $self->{'queue'} })
    {
      my $pcb = $dq->{'pcb'} or die "no pcb association found.";
      #print "Process ID    Filename      Starting Location     Mode\n";
      print sprintf("%-15s", $self->{'id'});
      print sprintf("%-15s", $pcb->{'pid'});
      print sprintf("%-15s", $dq->{'filename'});
      print sprintf("%-20s", $dq->{'start_loc'});
      print sprintf("%-10s", $dq->{'mode'});
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
  while (my($dev_type,$num_devices) = each %{ $devs_to_create } )
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

  #use Data::Dumper; print Dumper $DEVICES;
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
    unless ($filename =~ /^[\w\.]+$/) {
      print "Aborting request. Invalid filename!\n";
      return 0;
    }

    print "Enter starting location: ";
    my $start_loc = <STDIN>; chomp($start_loc);
    unless ($start_loc =~ /^\d+$/) {
      print "Aborting request. Invalid location (must be an integer)!\n";
      return 0;
    }

    my $mode = 'w';
    if ($code ne 'p')
    {
      print "Enter mode (r or w): ";
      $mode = <STDIN>; chomp($mode);
      unless ($mode =~ /^[rRwW]$/) {
        print "Aborting request. Invalid mode! (must be 'r' or 'w')!\n";
        return 0;
      }
      $mode = lc($mode);
    }

    my $dq = DQ->new(pcb => $pcb, filename => $filename, start_loc => $start_loc, mode => $mode);
    push @{ $DEVICES->{$type}->{"$type$num"}->{queue} }, $dq;
  }
  else
  {
    print "Abording request. Device not valid.\n";
  }

  return 1;
}

sub dev_dequeue($$) {
  my $code = shift or die "no code";
  my $num = shift or die "no num";

  my $type = code2type($code) or die "invalid code";

  if (exists $DEVICES->{$type}->{"$type$num"}->{'queue'}) # valid device
  {
    my $dq = shift @{ $DEVICES->{$type}->{"$type$num"}->{'queue'} };
    my $pcb = $dq->{'pcb'};

    #if no process in cpu, return to cpu, otherwise put back in ready
    if (defined $CPU_PCB)
    {
      push @READY_QUEUE, $pcb; # back on ready queue
    }
    else
    {
      $CPU_PCB = $pcb;
    }

    return 1;
  }
  return 0;
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
      if (defined $CPU_PCB)
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
      print "Snapshot mode. (Available subcommands: 'r', 'p', 'c', 'd', 'a'): ";
      my $subcmd = <STDIN>;
      chomp($subcmd);

      if ($subcmd eq 'r')
      {
        #print "=== Process List ===\n";
        print "\n";
        print sprintf("%-20s %-20s %-20s", "PROCESS ID", "STATUS", ""), "\n";
        if (defined $CPU_PCB) 
        { 
        print sprintf("%-20s %-20s %-20s", $CPU_PCB->{'pid'}, "cpu", ""), "\n";
          for my $pcb (@READY_QUEUE) {
            print sprintf("%-20s %-20s %-20s", $pcb->{'pid'}, "ready", ""), "\n";
          }
        }
      }
      elsif ($subcmd =~ /^[aA]$/)
      {
        my $no_header = 0;
        for my $type (sort keys %{ DEV_TYPES() })
        {
          #print "=== $type device queue ===\n";
          for my $id (sort keys %{ $DEVICES->{$type} })
          {
            my $dev = $DEVICES->{$type}->{$id};
            $dev->dump($no_header++);
          }
        }
      }
      elsif ($subcmd =~ /^[pPcCdD]$/)
      {
        my $type = code2type($subcmd);
        #print "=== $type device queue ===\n";
        my $no_header = 0;
        for my $id (sort keys %{ $DEVICES->{$type} })
        {
          my $dev = $DEVICES->{$type}->{$id};
          $dev->dump($no_header++);
        }
      }
      else
      {
        print "Subcommand not recongnized. Returning to run mode.\n";
      }
    }

    elsif ($cmd =~ /^([pcd])(\d+)$/)
    {
      if ($CPU_PCB)
      {
        print "Device request... ";
        if (dev_queue($CPU_PCB, $1, $2))
        {
          # now change the cpu pcb
          $CPU_PCB = shift @READY_QUEUE;
        }
      }
      else
      {
        print "No current process.\n";
      }
    }

    elsif ($cmd =~ /^([PCD])(\d)$/)
    {
      if (dev_dequeue($1, $2))
      {
        print "Completed and de-queued IO for process.\n";
      }
      else
      {
        print "Aborting request. Device not valid.\n";
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

