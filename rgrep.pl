#!/usr/bin/perl

use Getopt::Long;
use strict;

my $filepattern;
my $depth;
my $searchpattern;
my $findcmd;

GetOptions ("depth=i" => \$depth)
  or &HELP_MESSAGE();

$searchpattern = $ARGV[0];
$filepattern = $ARGV[1];

my $default_depth = 1;
if (! $depth) {
	$depth = $default_depth;	
}
if ($filepattern) {
	$filepattern =~ s/(?<!\\)([?*])/\\$1/g;
	$findcmd = "find . -name $filepattern -maxdepth $depth";
} else {
	$findcmd = "find . -maxdepth $depth";
}
if (! $searchpattern) {
	&HELP_MESSAGE();
}

#print "findcmd: '$findcmd'\n";

my @files = `$findcmd`;

foreach my $f (@files) {
	chomp($f);
	my $grepcmd = "grep $searchpattern $f";
	#print "$grepcmd\n";
	my $grep = `$grepcmd`;
	if ($grep eq '') {
		next;
	}
	chomp($grep);
	print "$f:\n$grep\n\n";
}

sub HELP_MESSAGE {
    print "\n\n";
    print "\t rgrep <pattern> <filepattern> -d <recursion depth>\n\n";
	print "\t-d\trecursion depth (default: $default_depth)\n";
	exit;
}


