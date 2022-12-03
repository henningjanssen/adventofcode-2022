#!/usr/bin/env perl
use strict;

my $filename = "input.txt";

my $alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
my $score = 0;

open(fhandle, '<', $filename) or die $!;

while(<fhandle>) {
    my $linelength = length($_);

    my $firstCompartment = substr($_, 0, $linelength/2);
    $firstCompartment =~ s/^\s+|\s+$//g;
    my @firstCompArr = split '', $firstCompartment;
    @firstCompArr = sort @firstCompArr;

    my $secondCompartment = substr($_, $linelength/2, $linelength-2);
    $secondCompartment =~ s/^\s+|\s+$//g;
    my @secondCompArr = split '', $secondCompartment;
    @secondCompArr = sort @secondCompArr;

    my $leftIdx = 0;
    my $rightIdx = 0;

    while($leftIdx < scalar @firstCompArr && $rightIdx < scalar @secondCompArr) {
        my $left = @firstCompArr[$leftIdx];
        my $right = @secondCompArr[$rightIdx];
        if ($left eq $right) {
            $score += index($alphabet, $left) + 1;
            last;
        }
        if($left lt $right) {
            $leftIdx++;
        } else {
            $rightIdx++;
        }
    }
}


close(fhandle);

print $score, "\n";
