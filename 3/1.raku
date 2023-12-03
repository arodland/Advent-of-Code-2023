my @m = $*ARGFILES.lines».comb».Array;
my @rc = @m.keys X @m[0].keys;
my @sym_pos;

for @rc -> ($r, $c) {
    if @m[$r][$c] !~~ /\d|'.'/ {
        @sym_pos.push(($r, $c));
    }
}

my $sum = 0;
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

        my $adjacent = False;
        for @sym_pos -> [$sr, $sc] {
            if $sr >= $r-1 && $sr <= $r+1 && $sc >= $start-1 && $sc <= $end {
                $adjacent = True;
            }
        }
        if $adjacent {
            say "YES: $num at [$r, $start] - [$r, $end]";
            $sum += $num;
        } else {
            say " NO: $num at [$r,$start] - [$r,$end]";
        }
        $start = $end;
    }
}

say "sum: $sum";
