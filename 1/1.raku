my $sum = 0;
for $*ARGFILES.lines -> $line {
    my $first = $line ~~ /\d/;
    my $last = $line.flip ~~ /\d/;
    my $num = 10*$first+$last;
    say $num;
    $sum += $num;
}
say $sum;
