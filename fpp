#!/usr/bin/perl -w
use strict;

my @defs;
use Getopt::Long;
Getopt::Long::Configure("bundling");
GetOptions("D=s" => \@defs);

my $hash={};
map {$hash->{$_}=1} @defs;

# state	event		next	action
# 0	#ifdef DEFINED	1	-
# 0	#ifdef UNDEF 	2	-
# 0	#endif		0	-
# 0	any		0	print
# 1	#endif		0	-
# 1	any		1	print
# 2	#endif		0	-
# 2	any		2	-

my $state=0;
while (<>) {
	if ($state==0) {
		if (/^#ifdef\s+(\S+)$/) {
			if ($hash->{$1}) {
				$state=1;
			} else {
				$state=2;
			}
			next;
		}
		if (/^#endif$/) {
			next;
		}
		print;
		next;
	}
	if ($state==1) {
		if (/^#endif$/) {
			$state=0;
			next;
		}
		print;
		next;
	}
	if ($state==2) {
		if (/^#endif$/) {
			$state=0;
			next;
		}
		next;
	}
	die "unknown state: $state";
}
