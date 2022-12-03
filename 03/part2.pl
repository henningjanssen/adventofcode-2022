#!/usr/bin/env perl
use strict;

my $filename = "input.txt";

my $alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
my $score = 0;

my $member = 0;
my @backpacks = ("", "", "");

open(fhandle, '<', $filename) or die $!;

while(<fhandle>) {
    my $line = $_;
    $line =~ s/^\s+|\s+$//g;
    @backpacks[$member] = $line;
    $member++;

    if($member == 3) {
        $member = 0;

        my @leftArr = split '', @backpacks[0];
        @leftArr = sort @leftArr;
        my $leftIdx = 0;

        my @rightArr = split '', @backpacks[1];
        @rightArr = sort @rightArr;
        my $rightIdx = 0;

        my @kiddoArr = split '', @backpacks[2];
        @kiddoArr = sort @kiddoArr;
        my $kiddoIdx = 0;

        OUTER:
        while($leftIdx < scalar @leftArr && $rightIdx < scalar @rightArr) {
            my $left = @leftArr[$leftIdx];
            my $right = @rightArr[$rightIdx];

            if($left eq $right) {
                while($kiddoIdx < scalar @kiddoArr) {
                    my $kiddo = @kiddoArr[$kiddoIdx];
                    if ($kiddo eq $left) {
                        $score += index($alphabet, $left) + 1;
                        last OUTER;
                    } elsif ($kiddo gt $left) {
                        last;
                    }
                    $kiddoIdx++;
                }
            }

            if ($left lt $right) {
                $leftIdx++;
            } else {
                $rightIdx++;
            }
        }
    }
}


close(fhandle);

print $score, "\n";
