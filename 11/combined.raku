my $EXPANSION = @*ARGS.shift.Int;

my @map = $*ARGFILES.lines».comb».Array;
my @empty_rows = @map.keys.grep: { all(@map[$_]) eq '.' };
my @empty_cols = @map[0].keys.grep: { all(@map[*;$_]) eq '.' };
my @rc = @map.keys X @map[0].keys;
my @galaxies = @rc.grep: { @map[$_[0];$_[1]] eq '#' };

@galaxies = @galaxies.map: -> ($r, $c) {
    [
        $r + ($EXPANSION-1) * @empty_rows.grep({ $_ < $r }).elems,
        $c + ($EXPANSION-1) * @empty_cols.grep({ $_ < $c }).elems,
    ];
}

my $total = 0;
for @galaxies.combinations(2) -> ($g1, $g2) {
    my $dist = [+] ($g1 «-» $g2)».abs;
    $total += $dist;
}

say $total;
