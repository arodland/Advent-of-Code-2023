my @m = $*ARGFILES.lines».comb».Array;
my @rc = @m.keys X @m[0].keys;
my @gear_pos;
my @gear_adjacencies;

for @rc -> ($r, $c) {
    if @m[$r][$c] eq '*' {
        @gear_pos.push(($r, $c));
    }
}

for @m.keys -> $r {
    my $start = 0;
    NUM: while $start < @m[$r].elems {
        while @m[$r][$start] !~~ /\d/ {
            $start++;
            last NUM if $start >= @m[$r].elems;
        }
        my $num = @m[$r][$start].Int;
        my $end = $start + 1;
        while $end < @m[$r].elems && @m[$r][$end] ~~ /\d/ {
            $num = $num * 10 + @m[$r][$end].Int;
            $end++;
        }

        for @gear_pos.kv -> $gi, [$sr, $sc] {
            if $sr >= $r-1 && $sr <= $r+1 && $sc >= $start-1 && $sc <= $end {
                say "gear $gi at [$sr, $sc] is adjacent to $num at [$r, $start] - [$r, $end]";
                @gear_adjacencies[$gi] //= [];
                @gear_adjacencies[$gi].push($num);
            }
        }
        $start = $end;
    }
}

say [+] gather {
    for @gear_adjacencies -> @adj {
        if @adj.elems == 2 {
            take [*] @adj;
        }
    }
}
