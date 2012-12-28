#!/usr/bin/perl -w

use strict;
use warnings;
my $x = 0;

# from http://www.perlmonks.org/?node_id=518887
sub integrate(&@)
{
    my $sum;
    my $f = shift;
    my %o = (from => 0, by => 0.0001, @_);
    for ($o{from} / $o{by} .. $o{to} / $o{by}) {
        $x = $_ * $o{by};
        $sum += &$f * $o{by};
    }
    $sum;
}

# changed to use computed dx
sub integrate2(&@)
{
    my $sum;
    my $fx = shift;
    my %o = (from => 0.0, steps => 100000, @_);
    my $dx = ($o{to} - $o{from}) / $o{steps};
    for (0 .. $o{steps}) {
        $x = $_ * $dx + $dx/2; # midpoint
        $sum += &$fx * $dx;
    }
    $sum;
}

# changed function symantics
sub integrate3
{
    my $sum;
    my $fx = shift;
    my %o = (from => 0.0, steps => 100000, @_);
    my $dx = ($o{to} - $o{from}) / $o{steps};
    for (0 .. $o{steps}) {
        my $x = $_ * $dx + $dx/2; # midpoint
        $sum += &$fx($x) * $dx;
    }
    $sum;
}

# eliminated the use of lexical variable x
# not as pretty as using $x, but cleaner
sub integrate4
{
    my $sum;
    my $fx = shift;
    my %o = (from => 0.0, steps => 100000, @_);
    my $dx = ($o{to} - $o{from}) / $o{steps};
    for my $slice (0 .. $o{steps}) {
        $sum += &$fx($slice * $dx) * $dx;
    }
    $sum;
}
print  "\n", integrate { $x**3 } to => 1; print "\n";
print  "\n", integrate2 { $x**3 } to => 1; print "\n";
print  "\n", integrate3( sub { @_[0]**3 }, to => 1); print "\n";
print  "\n", integrate4( sub { @_[0]**3 }, to => 1); print "\n";

