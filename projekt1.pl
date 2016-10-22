#!/usr/bin/perl

#print "Hello World!\n";

open(DATA,"<test.txt") or die "Couldn't open file test.txt, $!";
@lines=<DATA>;
close(DATA);
print '\documentclass{article}'."\n";
print '\begin{document}'."\n";
print '\begin{tabular}{|c|c|c|}';
foreach(@lines)
{
	print '\hline'."\n";
	print join(' & ',split(/ /,$_));
	print "\\\\\n";
}
print '\hline'."\n";
print '\end{tabular}'."\n";
print '\end{document}'."\n";