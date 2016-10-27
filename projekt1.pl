#!/usr/bin/perl

#print "Hello World!\n";

use strict;
#use warnings;

use List::Util qw[min max];
use Getopt::Long;
use Scalar::Util qw(looks_like_number);

my $filename="test.txt";
my $transpose=0;
my $sum_up_rows=0;
my $sum_up_cols=0;
my $cols=0;
GetOptions(
			'filename=s' => \$filename,
			'transpose' => \$transpose, 
			'sum_up_rows' => \$sum_up_rows,
			'sum_up_cols' => \$sum_up_cols,
			'cols=i' => \$cols
			) or die "Usage: $0 --filename file --transpose --sum_up_rows --sum_up_cols --cols i\n";


open(DATA,"<".$filename) or die "Couldn't open file $filename, $!";
my @lines=<DATA>;
close(DATA);

my @matrix;
my $width=0;
my $height=0;
my @row;
my $row_it=0;
my $line_counter=0;

foreach(@lines)
{
	my @line=split(/ /,$_);
	if($cols>0)
	{
		for(my $i=0;$i<scalar @line;$i++)
		{
			$row[$row_it]=$line[$i];
			$row_it++;
			if($row_it>=$cols)
			{
				$row_it=0;
				push @{ $matrix[$height] }, @row;
				$width=$cols;
				$height++;
			}
			elsif($i==$#line and $#lines<=$line_counter)
			{
				for(my $j=$row_it;$j<$width;$j++)
				{
					$row[$j]='';
				}
				push @{ $matrix[$height] }, @row;
				$height++;
			}
		}
	}
	else
	{
		push @{ $matrix[$height] }, @line;
		$width=max($width,scalar @line);
		$height++;
	}
	$line_counter++;
}

#print "width: $width, height: $height\n";

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
				$col_sum[$j]+=$matrix[$j]->[$i];
			}
			print $matrix[$j]->[$i];
		}
		else
		{
			if(looks_like_number($matrix[$i]->[$j]))
			{
				$row_sum+=$matrix[$i]->[$j];
				$col_sum[$j]+=$matrix[$i]->[$j];
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
if($sum_up_cols)
{
	print '\hline'."\n";
	for(my $j=0;$j<$width;$j++)
	{
		print $col_sum[$j];
		if($j<($width-1))
		{
			print " & ";
		}
		elsif($sum_up_rows)
		{
			print " & ";
		}
	}
	print "\\\\\n";
}
print '\hline'."\n";
print '\end{tabular}'."\n";
print '\end{document}'."\n";