my @map = $*ARGFILES.lines».comb».Array;
my @rows = @map.keys;
my @cols = @map[0].keys;
my @rc = (@rows X @cols)».Array;

my @barriers = @rc.grep: { @map[$_[0]; $_[1]] eq '#' };
my @boulders = @rc.grep: { @map[$_[0]; $_[1]] eq 'O' };

sub shift-north {
    for @cols -> $col {
        my @rocks = @boulders.grep({ $_[1] == $col }).sort({ $^a[0] <=> $^b[0] });
        my @stops = @barriers.grep({ $_[1] == $col }).sort({ $^a[0] <=> $^b[0] });
        my $next_open = 0;
        while @rocks.elems > 0 {
            if @stops.elems == 0 || @rocks[0][0] < @stops[0][0] {
                @rocks[0][0] = $next_open;
                $next_open++;
                @rocks.shift;
            } else {
                $next_open = @stops[0][0] + 1;
                @stops.shift;
            }
        }
    }
}

sub get-load {
    return [+] @map.elems «-» @boulders[*; 0];
}

sub rotate-cw {
    @barriers = @barriers.map: { [ $_[1], @map.end-$_[0] ] };
    @boulders = @boulders.map: { [ $_[1], @map.end-$_[0] ] };
}

sub visualize {
    my @tmp = (^@rows.elems).map: { [ '.' xx @rows.elems ] };
    for @boulders -> $b {
        @tmp[$b[0]; $b[1]] = 'O';
    }
    for @barriers -> $b {
        @tmp[$b[0]; $b[1]] = '#';
    }
    return @tmp».join.join("\n");
}

sub hash-key {
    return @boulders.sort({ $^a cmp $^b })».join(",").join(";");
}

my %seen;
my @loads;

for 1..1000 -> $iter {
    for ^4 {
        shift-north;
        rotate-cw;
    }
    my $load = get-load;
    say "$iter: $load";
    @loads[$iter] = $load;

    my $key = hash-key;
    if %seen{$key}:exists {
        say "Pattern from iter { %seen{$key} } repeated at iter $iter";
        my $mod = $iter - %seen{$key};
        my $offset = %seen{$key};
        my $proj = (1000000000 - $offset) % $mod + $offset;
        say "1000000000 should equal iter $proj, load { @loads[$proj] }";
        last;
    }
    %seen{$key} = $iter;
    @loads[$iter] = $load;
}

