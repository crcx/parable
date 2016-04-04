#!/usr/bin/perl

use strict;
use warnings;

# read in the contents of the file
my $contents;
open(TMP, "<$ARGV[0]") or die ("Failed to open $ARGV[0]: $!");
{
    local($/) = undef;
    $contents = <TMP>;
}
close(TMP);

# split the contents around each character
my @bits = split(//, $contents);

# build the hash of each character with it's respective count
my %counts = map { 
    # use lc($_) to make the search case-insensitive
    my $foo = $_; 

    # filter out newlines
    $_ ne "\n" ? 
        ($foo => scalar grep {$_ eq $foo} @bits) :
        () } @bits;

# reverse sort (highest first) the hash values and print
foreach(reverse sort {$counts{$a} <=> $counts{$b}} keys %counts) {
    print "$_: $counts{$_}\n";
}
