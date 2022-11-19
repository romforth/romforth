#!/usr/bin/perl -w

# fpp : cpp-like preprocessor for .4th files, handles #{ifdef/#}ifdef/#{if/#}if
# fpp was written because cpp fails on the .4th input files
#
# Copyright (c) 2022 Charles Suresh <romforth@proton.me>
# SPDX-License-Identifier: AGPL-3.0-only
# Please see the LICENSE file for the Affero GPL 3.0 license details

use strict;

my (@defs, $config);
use Getopt::Long;
Getopt::Long::Configure("bundling");
GetOptions("D=s" => \@defs, "c=s" => \$config);

my $hash={};
for my $d (@defs) {
	# -D options could be in the form -Dfoo or -Dbar=baz
	if ($d=~/^[^\=]+\=[^\=]+$/) { # ensure there is just one single '='
		my ($l,$r)=split(/\=/, $d);
		$hash->{$l}=$r;
		next;
	}
	$hash->{$d}=1;
}

if ($config) { # assume config entries are always in the form foo=bar
	open(my $fh, $config);
	while (<$fh>) {
		chomp;
		my ($l,$r)=split(/\=/);
		$hash->{$l}=$r;
	}
	close($fh);
}

# state	event		next	action
# 0	#{ifdef DEFINED	push,1	-
# 0	#{ifdef UNDEF 	push,2	-
# 0	#{if true	push,1	-
# 0	#{if false	push,2	-
# 0	any		0	print
# 1	#}ifdef		pop	-
# 1	#}if		pop	-
# 1	#{ifdef DEFINED	push,1	-
# 1	#{ifdef UNDEF 	push,2	-
# 1	#{if true	push,1	-
# 1	#{if false	push,2	-
# 1	any		1	print
# 2	#}ifdef		pop	-
# 2	#}if		pop	-
# 2	any		2	-

my $states=[];
my $state=0;
my $err=33; # first "visible"/printable ASCII character

sub replace {
	my ($k,$v);
	my ($m)=@_;
	while (($k,$v)=each %$hash) {
		$m=~s/$k/$v/g;
	}
	return $m;
}

sub replacevar {
	my ($s)=@_;
	my $k=substr($s,1); # skip the leading '$'
	my $v=$hash->{$k};
	return $v if (defined $v);
	die "unknown variable $k";
}

sub starting {
	if (/^\#\{ifdef\s+(\S+)$/) {
		push @$states, $state;
		if ($hash->{$1}) {
			$state=1;
		} else {
			$state=2;
		}
		return 1;
	}
	if (/^\#\{if\s+(.*)$/) {
		push @$states, $state;
		my $m=replace($1);
		if (eval($m)) {
			$state=1;
		} else {
			$state=2;
		}
		return 1;
	}
	s/\#assert/$err emit/ and $err++;
	return 0;
}

sub stopping {
	return 1 if starting();
	if (/^\#\}ifdef$/) {
		$state=pop @$states;
		return 1;
	}
	if (/^\#\}if$/) {
		$state=pop @$states;
		return 1;
	}
	return 0;
}

while (<>) {
	s/(\$[A-Z]+)/replacevar($1)/eg; # replace $FOO variables with value
	if ($state==0) {
		next if starting();
		print;
		next;
	}
	if ($state==1) {
		next if stopping();
		print;
		next;
	}
	if ($state==2) {
		next if stopping();
		next;
	}
	die "unknown state: $state";
}
