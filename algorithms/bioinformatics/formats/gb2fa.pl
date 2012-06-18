#!/usr/bin/perl -w
#
# based on example in http://bioperl.org/pipermail/bioperl-l/2009-August/030978.html
#
use strict;
use Bio::SeqIO;

use constant USAGE => "gb2fa.pl <infilepath> <outfilepath>";

my $inFile  = shift @ARGV or die USAGE;
my $outfile = shift @ARGV or die USAGE;

#OPEN A SEQUENCE FILE OF INTEREST ($inFile) AND CREATE A SEQUENCE  STREAM ($in)
my $in  = Bio::SeqIO->new(-file => "$inFile" , '-format' => 'GenBank');

#OPEN AN OUPUT FILE OF INTEREST ($outfile)AND CREATE AN OUTPUT  SEQUENCE STREAM ($out)
#NOTICE HOW WE SET -file FOR OUTPUT WITH THE > SYMBOL HERE:
my $out = Bio::SeqIO->new(-file => ">$outfile" ,'-format' => 'Fasta');

#NOW LET'S DO THE CONVERSION AND DUMP THE OUTPUT
#INSTEAD OF DOING THIS
#print $out $_ while <$in>;
#TRY THIS
while(my $seq = $in->next_seq() ){
	$out->write_seq($seq)
}
