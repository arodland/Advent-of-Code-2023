sub valid ($cubes) {
    my ($count, $color) = $cubes.words;
    return False if $color eq 'green' and $count > 13;
    return False if $color eq 'red' and $count > 12;
    return False if $color eq 'blue' and $count > 14;
    return True;
}

my $sum = 0;
for $*ARGFILES.lines -> $line is copy {
    $line ~~ s/^'Game '(\d+)': '//; my $id = $0.Int;
    my @chunks = $line.split(rx/';' \s*/)».split(rx/',' \s*/);
    say @chunks;
    my $valid = all(@chunks.deepmap(&valid)».all);
    if $valid {
        $sum += $id;
    }
}

say $sum;
