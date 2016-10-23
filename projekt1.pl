#!/usr/bin/perl

#print "Hello World!\n";

use strict;
#use warnings;

use List::Util qw[min max];
use Getopt::Std;

open(DATA,"<test.txt") or die "Couldn't open file test.txt, $!";
my @lines=<DATA>;
close(DATA);

my @matrix;
my $width=0;
my $height=0;

foreach(@lines)
{
	my @line=split(/ /,$_);
	push @{ $matrix[$height] }, @line;
	$width=max($width,scalar @line);
	$height++;
}

#print "width: $width, height: $height\n";



print '\documentclass{article}'."\n";
print '\begin{document}'."\n";
print '\begin{tabular}{|';
for(my $i=0;$i<$width;$i++)
{
	print "c|";
}
print '}';
for(my $i=0;$i<$height;$i++)
{
	print '\hline'."\n";
	for(my $j=0;$j<$width;$j++)
	{
		print $matrix[$i]->[$j];
		if($j<($width-1))
		{
			print " & ";
		}
	}
	print "\\\\\n";
}
print '\hline'."\n";
print '\end{tabular}'."\n";
print '\end{document}'."\n";