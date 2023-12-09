my $sum = 0;

for $*ARGFILES.lines -> $line {
    my @x = $[ $line.words».Int ];
    while not all(@x[*-1]) == 0 {
        my @diff = @x[*-1].rotor(2=>-1).map: { $_[1] - $_[0] }
        @x.push(@diff);
    }
    for @x.keys[1..*].reverse -> $i {
        @x[$i-1].unshift: @x[$i-1][0] - @x[$i][0];
    }
    $sum += @x[0][0];
}

say $sum;
