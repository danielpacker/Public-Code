#!/usr/bin/perl -w
#
# Dirty proof of concept inline documentation suppoer for BNGL
# usage: perl inline.pl myscript.bngl > output.html
#
# by Daniel Packer


use strict;
use warnings;

use constant SECTION_NAMES => (
   'parameters',
   'reaction rules',
   'observables',
   'seed species',
   );



main();
exit(0);

sub main {
  my $script_file = $ARGV[0] or die "No script name provided\n";
  my $script = read_script($script_file);
  my %sections = get_sections($script);
  my $output;

  use Data::Dumper; 
 # print Dumper \%sections;

  for my $sec_name (SECTION_NAMES)
  {
    my @pairs = get_doc_pairs($sections{$sec_name});
    #print Dumper \@pairs;
    $output .= render_section($sec_name, @pairs);

  }
  print html_wrapper($output, $script_file);
}


sub html_wrapper {
  my $output = shift or die "no output";
  my $script_file = shift or die "no script file";
  return qq(
<html>
  <head><title>Documenation for $script_file</title></head>
  <style type="text/css">
    #key { font-weight: bold; padding-right: 10px; float: left; clear: both; width: 150px; }
    #value { }
    #source { }
    div.doc { margin-bottom: 5px; padding-left: 10px; background-color: #DDD; }
    * { line-height: 1.6; }
  </style>
  <body>
    <h1>Documentation for $script_file</h1>
    $output
  </body>
</html>
    );
}

sub render_section {
  my $sec_name = shift or die "no section name";
  my @doc_pairs = @_;

  my $output;
  $output .= "<h2>$sec_name</h2>\n\n";
  for my $dp (@doc_pairs)
  {
    my $line = $dp->{'line'};
    my $doc = $dp->{'doc'};
    my %doc_key_vals = parse_doc($doc);
    $output .= qq(<div class="doc">\n);
    for my $key (keys %doc_key_vals)
    {
      $output .= qq(<div id="key">$key</div><div id="val">$doc_key_vals{$key}</div>\n);
    }
    $output .= qq(<div id="key">source</div><div id="value">$line</div>\n\n);
    $output .= qq(</div>\n);
  }
  return $output;
}


# parse a doc block
sub parse_doc {
  my $doc = shift;
  my %doc_key_vals = ();
  for my $line (split("\n", $doc))
  {
    if ($line =~ /\\(\w*) ([\w\s]+)/)
    {
      #print "KEY: $1 VAL: $2\n";
      $doc_key_vals{$1} = $2; 
    }
  }
  return %doc_key_vals;
}


sub read_script {
  my $script_filename = shift or die "No script filename.";

  die "File '$script_filename' not found" if (! -e $script_filename);
  open OFH, "<$script_filename" or die "Couldn't open file '$script_filename': $!";
  my $script_text = do { local $/; <OFH> };
  close OFH;

  my $test_script = q[
  begin parameters
  /*! \desc this is a test description
   *  \type test type
   */
  MyParam 0.001
  end parameters

  begin species
  /*! \desc this is a test species desc
   *  \type enzyme
   */
  egf(r)                           egf_tot
  end species


  ];

  return $script_text;
}



sub get_doc_pairs {
  my $script = shift;

  my $context;
  my $get_next_line;
  my @pairs = ();
  my $doc;

  for my $line (split("\n", $script))
  {
    if ($line =~ /\/\*\!/)
    {
      $context = 1;
    }

    if ($line =~ /\*\//)
    {
      undef $context;
      $get_next_line=1;
      $doc .= "$line\n";
      next;
    }
    $doc .= "$line\n" if ($context);

    if ($get_next_line)
    {
      # get the next line, it's associated with the docs above
      if ($line =~ /^\s*$/)
      {
      }
      else 
      {
        $get_next_line=0;
        push @pairs, { 'line' => $line, 'doc' => $doc };
        $doc = "";
      }
    }
  }
  
  #  use Data::Dumper; print Dumper \@pairs;
  return @pairs;
}



sub get_sections {

  my $script = shift or die "No script provided";
  my %sections = ();

  my $matches = join("|", SECTION_NAMES);
  #print "matches: $matches\n";

  my $context;
  for my $line (split("\n", $script))
  {
    #print "LINE: $line\n";
    if ($line =~ /begin ($matches)/)
    {
      $context = $1;
      #print "new context: $context\n";
    }

    if ($line =~ /end ($matches)/)
    {
      undef $context;
    }
    $sections{$context} .= "$line\n" if (defined $context);
  }

  return %sections;
}

