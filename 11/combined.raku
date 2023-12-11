my $EXPANSION = @*ARGS.shift.Int;

my @map = $*ARGFILES.lines».comb».Array;
my @empty_rows = @map.keys.grep: { all(@map[$_]) eq '.' };
my @empty_cols = @map[0].keys.grep: { all(@map[*;$_]) eq '.' };
my @rc = @map.keys X @map[0].keys;
my @galaxies = @rc.grep: { @map[$_[0];$_[1]] eq '#' };

for @galaxies.kv -> $i, $g {
    @galaxies[$i] = [
        $g[0] + ($EXPANSION-1) * @empty_rows.grep({ $_ < $g[0] }).elems,
        $g[1] + ($EXPANSION-1) * @empty_cols.grep({ $_ < $g[1] }).elems,
    ];
}

my $total = 0;
for @galaxies.keys -> $g1 {
    for $g1 ^..^ @galaxies.elems -> $g2 {
        my $dist = [+] (@galaxies[$g1] «-» @galaxies[$g2])».abs;
        $total += $dist;
    }
}

say $total;
