my $sum = 0;
for $*ARGFILES.lines -> $line is copy {
    $line ~~ s/'Card' \s+ (\d+) ': '//; my $cardid = $0;
    my ($winners, $numbers) = $line.split(' | ');
    $winners = Set($winners.words».Int);
    $numbers = Set($numbers.words».Int);
    my $matches = ($winners (&) $numbers);
    if $matches.elems > 0 {
        my $score = 2**($matches.elems - 1);
        $sum += $score;
    }
}
say $sum;
