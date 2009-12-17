#!/usr/bin/env perl

my ($version) = map { m/(\d+(?:\.\d+))/ } grep /^Version:/,
	`dpkg-parsechangelog`;

use Fatal qw(:void open chmod rename);

while (my $filename = shift) {
	open NEW, ">$filename.new";
	open OLD, "$filename";
	while (<OLD>) {
		if (m{__VERSION__}) {
			s{__VERSION__}{$version}g;
			s{^#*\s*}{};
		}
		print NEW $_;
	}
	my $perms = (stat OLD)[2];
	close NEW;
	close OLD;
	chmod $perms&07777, "$filename.new";
	rename "$filename.new", $filename;
}
