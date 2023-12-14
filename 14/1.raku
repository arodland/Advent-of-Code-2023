my @map = $*ARGFILES.lines».comb».Array;
my @rows = @map.keys;
my @cols = @map[0].keys;
my @rc = @rows X @cols;

my @barriers = @rc.grep: { @map[$_[0]; $_[1]] eq '#' };
my @boulders = @rc.grep: { @map[$_[0]; $_[1]] eq 'O' };

my $load = 0;

for @cols -> $col {
    my @rocks = @boulders.grep({ $_[1] == $col }).sort({ $^a[0] <=> $^b[0] });
    my @stops = @barriers.grep({ $_[1] == $col }).sort({ $^a[0] <=> $^b[0] });
    my @placed;
    my $next_open = 0;
    while @rocks.elems > 0 {
        if @stops.elems == 0 || @rocks[0][0] < @stops[0][0] {
            @placed.push: $next_open;
            $next_open++;
            @rocks.shift;
        } else {
            $next_open = @stops[0][0] + 1;
            @stops.shift;
        }
    }
    say "$col: ", @placed;
    $load += [+] @map.elems «-» @placed;
}

say $load;
