my $sum = 0;
my %queue = ();
for $*ARGFILES.lines -> $line is copy {
    $line ~~ s/'Card' \s+ (\d+) ': '//; my $cardid = $0;
    my $copies = (%queue{$cardid}:delete // 0) + 1;

    my ($winners, $numbers) = $line.split(' | ');
    $winners = Set($winners.words».Int);
    $numbers = Set($numbers.words».Int);
    my $matches = ($winners (&) $numbers);
    for $cardid+1 .. $cardid+$matches -> $newid {
        %queue{$newid} //= 0;
        %queue{$newid} += $copies;
    }
    $sum += $copies;
}
say $sum;
