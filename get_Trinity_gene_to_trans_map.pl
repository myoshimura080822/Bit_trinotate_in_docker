#!/usr/bin/env perl

use strict;
use warnings;


while (my $line = <>) {
    if ($line =~ m/>/) {
        my ($trans, $gene) = split(/\s+/, $line); 
        $trans =~ s/>//;
        print "$gene\t$trans\n";
    }
}

exit(0);

