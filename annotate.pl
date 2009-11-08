#!/usr/bin/perl
use strict;
use warnings;

open(my $file, '>>', ".ls") or die("Unable to open .ls");

if(@ARGV)
{
    print $file "@ARGV\n";
}
else
{
    my @lines = <>;
    print $file @lines;
}

close($file);
