# Star 1: raku combined.raku 0 input.txt
# Star 2: raku combined.raku 1 input.txt

sub score(@map, $delta=0) {
    say @map».join.join("\n");
    for 0 ..^ @map.end -> $r_row {
        my $r_sum = 2*$r_row+1;
        my $span = $r_row min (@map.end - ($r_row+1));
        my @from_rows = $r_row - $span .. $r_row;
        my @to_rows = $r_sum «-» @from_rows;
        if ([+] @map[@from_rows; *] «ne» @map[@to_rows; *]) == $delta {
            say "R {$r_row+1} (score {100 * ($r_row+1)})";
            return 100 * ($r_row + 1);
        }
    }

    for 0 ..^ @map[0].end -> $r_col {
        my $c_sum = 2*$r_col+1;
        my $span = $r_col min (@map[0].end - ($r_col+1));
        my @from_cols = $r_col - $span .. $r_col;
        my @to_cols = $c_sum «-» @from_cols;
        if ([+] @map[*; @from_cols] «ne» @map[*; @to_cols]) == $delta {
            say "C {$r_col+1} (score {$r_col+1})";
            return $r_col + 1;
        }
    }
}

my $delta = @*ARGS.shift.Int;

my @pattern;
my $total;
for $*ARGFILES.lines -> $line {
    if $line eq '' {
        $total += score(@pattern, $delta);
        @pattern = ();
        say "";
    } else {
        @pattern.push: $line.comb.list;
    }
}

$total += score(@pattern, $delta) if @pattern.elems > 0;

say $total;
        
