sub count ($cubes) {
    my ($count, $color) = $cubes.words;
    return $color => $count.Int;
}

my $sum = 0;
for $*ARGFILES.lines -> $line is copy {
    $line ~~ s/^'Game '(\d+)': '//; my $id = $0.Int;
    my @chunks = $line.split(rx/';' \s*/)».split(rx/',' \s*/);
    my @counts = @chunks.map: { Hash($_.map(&count)) };
    @counts = @counts.map: { $_<red green blue> «//» 0 }
    my $minimum = @counts.reduce({ $^a «max» $^b });
    my $power = [*] |$minimum;
    $sum += $power;
}

say $sum;
