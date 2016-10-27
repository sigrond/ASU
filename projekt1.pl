#!/usr/bin/perl

## autor: Tomasz Jakubczyk
## email: sigrond93@gmail.com
## Projekt 1 z ASU, zadanie 8 - tabelki
## data: 27 paź 2016

#print "Hello World!\n";

use strict;
#use warnings; ##wykożystuję dynamiczne zwiększanie rozmiarów, a ostrzeżenia w tex'u nie są potrzebne

use List::Util qw[min max];
use Getopt::Long;
use Scalar::Util qw(looks_like_number);

## znaleziona w internecie funkcja pozwalająca zamieńić \n na znak końca linii
sub handle_escapes
{
	my ($s) = @_;
	$s =~ s/\\([\\a-z])/
	$1 eq '\\' ? '\\' :
    $1 eq 'n' ? "\n" :
    do { warn("Unrecognised escape \\$1"); "\\$1" }
	/seg;
	return $s;
}

## wczytywanie opcji
my $filename="test.txt";
my $transpose=0;
my $sum_up_rows=0;
my $sum_up_cols=0;
my $cols=0;
my $separators=" ";
my $empty_row_header=0;##poziomy pusty nagłówek
my $empty_col_header=0;##pionowy pusty nagłówek
GetOptions(
			'filename=s' => \$filename,
			'transpose' => \$transpose, 
			'sum_up_rows' => \$sum_up_rows,
			'sum_up_cols' => \$sum_up_cols,
			'cols=i' => \$cols,
			'separators=s' => \$separators,
			'empty_row_header' => \$empty_row_header,
			'empty_col_header' => \$empty_col_header
			) or die "Usage: $0 --filename file --transpose --sum_up_rows --sum_up_cols --cols i --separators separators\n";

#print "separators before: {".$separators."}\n";
$separators=handle_escapes($separators);
#print "separators after: {".$separators."}\n";

## otwieranie pliku
## otwarcie pliku tekstowo pozwala na domyślne odzielanie wierszy znakim nowej lini, a kolumn innym separatorem (spacją)
open(DATA,"<".$filename) or die "Couldn't open file $filename, $!";
my @lines=<DATA>;
close(DATA);

my @matrix;
my $width=0;
my $height=0;
my @row;
my $row_it=0;
my $line_counter=0;

## zapisanie zawartości pliku do macierzy zgodnie z wybranymi zasadami
foreach(@lines)
{
	my @line=split(/$separators/,$_);
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

## nagłówek dokumentu i tabeli
print '\documentclass{article}'."\n";
print '\begin{document}'."\n";
print '\begin{tabular}{|';
my $real_width=0;
for(my $i=0;$i<$width or ($sum_up_rows and $i<=$width);$i++)
{
	print "c|";
	$real_width++;
}
if($empty_col_header)
{
	print "c|";
	$real_width++;
}
print '}';
my @col_sum;
for(my $i=0;$i<$width;$i++)
{
	$col_sum[$i]=0;
}
my $row_sum=0;
if($empty_row_header)
{
	print '\hline'."\n ";
	for(my $j=1;$j<$real_width;$j++)
	{
		print "& ";
	}
	print "\\\\\n";
}
## wypisywanie danych zgodnie z zadanymi zasadami
for(my $i=0;$i<$height;$i++)
{
	$row_sum=0;
	print '\hline'."\n";
	for(my $j=0;$j<$width;$j++)
	{
		if($empty_col_header and $j==0)
		{
			print " & ";
		}
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
	if($empty_col_header)
	{
		print " & ";
	}
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