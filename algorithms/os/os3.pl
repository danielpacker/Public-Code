#!/usr/bin/perl -w
#
# A program and objects that simulates an operating system
# by Daniel Packer <dp@danielpacker.org>
#

use strict;
use warnings;

use Data::Dumper;

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
  my %args = @_;

  my $self = {
    'id'        => $id,
    'queue'     => [],
    'cylinders' => 0,
    'type'      => '',
  };

  for my $arg (keys %args)
  {
    if (exists $self->{$arg})
    {
      if (($arg eq 'type') && ($args{$arg} eq 'disk'))
      {
        delete $self->{'queue'};
        $self->{'fwd_queue'} = [];
        $self->{'rev_queue'} = [];
        $self->{'last_cylinder'} = undef;
        $self->{'queue_dir'} = 'fwd'; # read fwd or rev queue
      }   
      $self->{$arg} = $args{$arg};
    }
  }

  bless $self, $class;
  return $self;
}

sub dump($) {
  my $self = shift;
  my $no_header = shift or 0;
  #print "=== Printer ID: ", $self->{'id'}, " ===\n";
  print "\n", sprintf("%-15s%-15s%-15s%-20s%-10s", "DEVICE ID", "PROCESS ID", "FILENAME", "STARTING lOCATION", "MODE"), "\n" unless ($no_header);

  my @queue; 
  if ($self->{'type'} eq 'disk')
  {
    @queue = (@{ $self->{'fwd_queue'} }, @{ $self->{'rev_queue'} });
  }
  else
  {
    @queue = @{ $self->{'queue'} };
  }

  if (scalar @queue)
  {
    #use Data::Dumper; print Dumper $self;
    for my $dq (@queue)
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
  "printer" => 1, "disk" => 1, "CD/RW" => 1, "CPU" => 1
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
my @READY_QUEUE     = ();
my $PROCESS_COUNT   = 1;     # pid value increments with each new process
my $CPU_PCB         = undef; # reference to PCB being worked on
my %CUR_BURST_TIMES = ();    # Track avg burst time by pid
my %NUM_BURST_TIMES = ();    # Track current total burst time by pid
my $TOTAL_SYSTEM_BURST = 0;  # total ms of burst for all finished procs
my $TOTAL_SYSTEM_PROCS = 0;  # total number of finished procs
my $TIME_SLICE_MSEC = 10;    # Time slice length (ms)
my $DEFAULT_DISK_CYL = 10000; # Default disk cylinders

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
      my $default = DEV_TYPES()->{$type};
      my $current_num_devs = $devs_to_create->{$type};
      print $dev_pos++, " ", $type, " ", "(currently $current_num_devs)", "\n";
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
        if ($num_devices > MAX_DEVS_PER_TYPE)
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

    # Get time slice
    my $ts = 0;
    while (length($ts) and ($ts < 1))
    {
      print "Enter length of timeslice(ms). Hit enter to accept default ($TIME_SLICE_MSEC): ";
      $ts = <STDIN>; chomp $ts;
      if (length($ts))
      { # leave default value
        if (($ts =~ /^\d+$/) and ($ts > 0))
        {
          $TIME_SLICE_MSEC = $ts;
        } 
        else 
        {
          print "ERROR: Please enter a number greater than 0\n";
          $ts = 0;
        }
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
    for my $dev_num (1..$num_devices)
    {
      #print "DeV TYPE: $dev_type\n";
      my $dc = 0;
      if ($dev_type eq 'disk')
      {

        # Get disk size 
        while (length($dc) and ($dc < 1))
        {
          print "Enter number of cylinders for disk $dev_num. (Enter for $DEFAULT_DISK_CYL):";
          $dc = <STDIN>; chomp $dc;
          if (length($dc))
          { # leave default value
            if (($dc =~ /^\d+$/) and ($dc > 0))
            {
            } 
            else 
            {
              print "ERROR: Please enter a number greater than 0\n";
              $dc = 0;
            }
          }
          else
          {
            $dc = $DEFAULT_DISK_CYL;
          }
        }
      }

      #next if $dev_num == 0; # device numbering starts at 1
      $DEVICES->{$dev_type}->{$dev_type . $dev_num} = 
        DEV->new(lc($dev_type) . $dev_num, 'cylinders' => $dc, 'type' => $dev_type);
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
  my $dev = $DEVICES->{$type}->{"$type$num"};
  print "DEV ID: ", $dev->{'id'}, "\n";

  if (my $dev = $DEVICES->{$type}->{"$type$num"})
  {
    print "Device valid. Issuing IO request.\n";
    print "Enter filename: ";
    my $filename = <STDIN>; chomp($filename);
    unless ($filename =~ /^[\w\.]+$/) {
      print "Aborting request. Invalid filename!\n";
      return 0;
    }

    if ($type eq 'disk')
    {
      print "Enter cylinder: ";
    }
    else
    {
      print "Enter starting location: ";
    }
    my $start_loc = <STDIN>; chomp($start_loc);
    unless ($start_loc =~ /^\d+$/) {
      print "Aborting request. Input must be an integer!\n";
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
    if ($type eq 'disk')
    {
      disk_queue($dev, $dq);
    }
    else
    {
      push @{ $DEVICES->{$type}->{"$type$num"}->{'queue'} }, $dq;
    }
  }
  else
  {
    print "Abording request. Device not valid.\n";
  }

  return 1;
}

sub disk_dequeue($) {
  my $dev = shift or die "no disk device";

  # we read from one queue while writing to the other
  my $writing_dir = $dev->{'queue_dir'};
  my $reading_dir = ($writing_dir eq 'fwd') ? 'rev' : 'fwd';
  
  # If reading queue is empty, switch queues
  my $queue = $dev->{$reading_dir.'_queue'};
  if (! scalar @$queue)
  {
    $dev->{'queue_dir'} = ($writing_dir eq 'fwd') ? 'rev' : 'fwd';
    $reading_dir = $writing_dir;
  }

  # If we're going fwd we want to sort the queue
  # in terms of increasing cylinder
  # if we're going rev we want to sort the queu
  # in terms of decreasing cylinder
  @{ $dev->{$reading_dir."_queue"} } = sort { $a->{'start_loc'} <=> $b->{'start_loc'} } @{ $dev->{$reading_dir."_queue"} };

  print "QUEUE: " . Dumper $dev->{$reading_dir.'_queue'};

  my $dq;
  if ($reading_dir eq 'fwd')
  {
  print "fwd!";
    $dq = shift @{ $dev->{$reading_dir.'_queue'} };
  }
  else
  {
    $dq = pop @{ $dev->{$reading_dir.'_queue'} };
  }

  print "DQ: " . Dumper $dq;

  return $dq;
}


sub disk_queue($$) {
  my $dev = shift or die "no disk device";
  my $dq  = shift or die "no queue item";

  my $dir = $dev->{'queue_dir'};
  push @{ $dev->{$dir.'_queue'} }, $dq;
  if ($dir eq 'fwd')
  {
    $dev->{$dir.'_queue'} = [ sort { $a->{'start_loc'} <=> $b->{'start_loc'} }  @{ $dev->{$dir.'_queue'} } ]; # sort queue
  }
  else
  {
    $dev->{$dir.'_queue'} = [ sort { $b->{'start_loc'} <=> $a->{'start_loc'} }  @{ $dev->{$dir.'_queue'} } ]; # sort queue
  }
  print "DIRECTION: $dir\n";
}


sub dev_dequeue($$) {
  my $code = shift or die "no code";
  my $num = shift or die "no num";

  my $type = code2type($code) or die "invalid code";

  if (exists $DEVICES->{$type}->{"$type$num"}) # valid device
  {
    my $dq;
    if ($type eq 'disk')
    {
      my $disk = $DEVICES->{$type}->{"$type$num"};
      $dq = disk_dequeue($disk);
    }
    else
    {
      $dq = shift @{ $DEVICES->{$type}->{"$type$num"}->{'queue'} };
    }
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

sub burst {
  my $pid = shift or die "no pcb";
  my $ms = shift or die "no ms";

  $NUM_BURST_TIMES{$pid}++;
  $CUR_BURST_TIMES{$pid} += $ms;
}
  

sub burst_time {
  my $pid = shift or die "no pcb";
  my $type = shift || 'total';

  my $total = $CUR_BURST_TIMES{$pid};

  if ($type eq 'average')
  {
    if (my $num = $NUM_BURST_TIMES{$pid})
    { 
      return $total/$num;
    }
    else
    {
      die "no nums found for pid"
        unless exists($NUM_BURST_TIMES{$pid});
    }
  } 
  elsif ($type eq 'system')
  {
    if ($TOTAL_SYSTEM_BURST)
    {
      return $TOTAL_SYSTEM_BURST/$TOTAL_SYSTEM_PROCS;
    }
    return 0;
  }
  return $total;
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
      $CUR_BURST_TIMES{$pcb->{'pid'}} = 0;
      $NUM_BURST_TIMES{$pcb->{'pid'}} = 0;
      if (defined $CPU_PCB)
      {
        push @READY_QUEUE, $pcb;
      }
      else
      {
        $CPU_PCB = $pcb;
      }
    }

    elsif ($cmd eq 'T') # timer interrupt
    {
      print "Timer interrupt! $TIME_SLICE_MSEC of burst time lapsed.\n";
      burst($CPU_PCB->{'pid'}, $TIME_SLICE_MSEC);
      # Move the current process to the back of the ready queue
      push @READY_QUEUE, $CPU_PCB;
      $CPU_PCB = shift @READY_QUEUE; # de-queue 1st pcb ready
    }
    elsif ($cmd eq 't') # terminate
    {
      if ($CPU_PCB)
      {
        print "Process terminating.\n";
        $TOTAL_SYSTEM_BURST += $CUR_BURST_TIMES{$CPU_PCB->{'pid'}};
        $TOTAL_SYSTEM_PROCS++;
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

      my $avgsys = burst_time(1, 'system');

      if ($subcmd eq 'r')
      {
        print "Average CPU time for completed processes (ms): $avgsys\n"; 
        #print "=== Process List ===\n";
        print "\n";
        print sprintf("%-15s %-15s %-20s %-20s", "PROCESS ID", "STATUS", "TOTAL BURST (ms)", "AVG BURST (ms)"), "\n";
        if (defined $CPU_PCB) 
        { 
        print sprintf("%-15s %-15s %-20s %-20s", $CPU_PCB->{'pid'}, "cpu", burst_time($CPU_PCB->{'pid'}), burst_time($CPU_PCB->{'pid'}, 'average')), "\n";
          for my $pcb (@READY_QUEUE) {
            print sprintf("%-15s %-15s %-20s %-20s", $pcb->{'pid'}, "ready", burst_time($pcb->{'pid'}), burst_time($pcb->{'pid'}, 'average')), "\n";
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
            print "DEVICE DUMPER: " . Dumper $dev;
            $no_header++;
            #$dev->dump($no_header++);
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
          my $ms = '';
          while (($ms !~ /^\d+$/) || ($ms > $TIME_SLICE_MSEC) || ($ms < 1))
          {
            print "Enter process burst time before syscall (1 to $TIME_SLICE_MSEC ms): ";
            $ms = <STDIN>; chomp $ms;
          }
          burst($CPU_PCB->{'pid'}, $ms);
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

    elsif ($cmd eq 'dump')
    {
      print "DEVICES:\n";
      print Dumper $DEVICES;
    }

    elsif (($cmd =~ /^[hH]$/) or ($cmd =~ /help/i) or ($cmd eq '?'))
    {
      my $help = q(
  COMMAND LIST:
  ?:  command list
  a:  new process
  t:  terminate current process
  pX: new printer syscall
  dX: new disk syscall
  cX: new CD/RW syscall
  T:  burst the CPU for one time slice
  s:  snapshot submenu
      --> snapshot options:
      r:  show processes in ready_queue/CPU
      a:  show all processes in device queues
      d:  show all processes in disk queues
      c:  show all processes in CD/RW queues
      p:  show all processes in printer queues
);
        print $help, "\n";
    }
 
    else
    {
      print "COMMAND NOT RECOGNIZED. TYPE \"?\" FOR HELP.\n\n";
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

