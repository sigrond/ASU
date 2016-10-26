#!/usr/bin/perl

#print "Hello World!\n";

use strict;
#use warnings;

use List::Util qw[min max];
use Getopt::Long;
use Scalar::Util qw(looks_like_number);

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

my $transpose=0;
my $sum_up_rows=0;
GetOptions('transpose' => \$transpose, 'sum_up_rows' => \$sum_up_rows) or die "Usage: $0 --transpose --sum_up_rows\n";

#print $transpose."\n";
if($transpose)
{
	#print "transpozycja\n";
	($width, $height)=($height, $width);
}

print '\documentclass{article}'."\n";
print '\begin{document}'."\n";
print '\begin{tabular}{|';
for(my $i=0;$i<$width or ($sum_up_rows and $i<=$width);$i++)
{
	print "c|";
}
print '}';
my @col_sum;
for(my $i=0;$i<$width;$i++)
{
	$col_sum[$i]=0;
}
my $row_sum=0;
for(my $i=0;$i<$height;$i++)
{
	$row_sum=0;
	print '\hline'."\n";
	for(my $j=0;$j<$width;$j++)
	{
		if($transpose)
		{
			if(looks_like_number($matrix[$j]->[$i]))
			{
				$row_sum+=$matrix[$j]->[$i];
				$col_sum[$i]=$matrix[$j]->[$i];
			}
			print $matrix[$j]->[$i];
		}
		else
		{
			if(looks_like_number($matrix[$i]->[$j]))
			{
				$row_sum+=$matrix[$i]->[$j];
				$col_sum[$i]=$matrix[$i]->[$j];
			}
			print $matrix[$i]->[$j];
		}
		if($j<($width-1))
		{
			print " & ";
		}
		elsif($sum_up_rows)
		{
			print " & ".$row_sum;
		}
	}
	print "\\\\\n";
}
print '\hline'."\n";
print '\end{tabular}'."\n";
print '\end{document}'."\n";