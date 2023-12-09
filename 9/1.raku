my $sum = 0;

for $*ARGFILES.lines -> $line {
    my @x = $[ $line.words».Int ];
    while not all(@x[*-1]) == 0 {
        my @diff = @x[*-1].rotor(2=>-1).map: { $_[1] - $_[0] }
        @x.push(@diff);
    }
    for @x.keys[1..*].reverse -> $i {
        @x[$i-1].push: @x[$i-1][*-1] + @x[$i][*-1];
    }
    $sum += @x[0][*-1];
}

say $sum;
