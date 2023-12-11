my @map = $*ARGFILES.lines».comb».Array;
my @rc = @map.keys X @map[0].keys;
my $start = @rc.first: { @map[$_[0]; $_[1]] eq 'S' };
my SetHash $visited;
my @queue = $[$start, 0];
my $maxdist = 0;
while my $next = @queue.shift {
    my ($pos, $dist) = @$next;
    my ($r, $c) = @$pos;
    next if $visited{"$r;$c"};
    $maxdist = $dist if $dist > $maxdist;

    $visited{"$r;$c"} = 1;
    my @neighbors = gather {
        take ($r-1, $c) if $r > 0 and @map[$r; $c] (elem) ('S', '|', 'J', 'L') and @map[$r-1; $c] (elem) ('|', '7', 'F');
        take ($r+1, $c) if $r < @map.end and @map[$r; $c] (elem) ('S', '|', '7', 'F') and @map[$r+1; $c] (elem) ('|', 'J', 'L');
        take ($r, $c-1) if $c > 0 and @map[$r; $c] (elem) ('S', '-', '7', 'J') and @map[$r; $c-1] (elem) ('-', 'F', 'L');
        take ($r, $c+1) if $c < @map[0].end and @map[$r; $c] (elem) ('S', '-', 'F', 'L') and @map[$r; $c+1] (elem) ('-', '7', 'J');
    }
    @neighbors = @neighbors.grep: { !$visited{$_.join(";")} };
    for @neighbors -> $n {
        @queue.push([$n, $dist+1]);
    }
}

# Fix the starting symbol
my ($r, $c) = @$start;
my $up = $visited{"{$r-1};$c"};
my $dn = $visited{"{$r+1};$c"};
my $lt = $visited{"$r;{$c-1}"};
my $rt = $visited{"$r;{$c+1}"};

if $up {
    if $dn {
        @map[$r; $c] = "|";
    } elsif $lt {
        @map[$r; $c] = "J";
    } else {
        @map[$r; $c] = "L";
    }
} elsif $lt {
    if $rt {
        @map[$r; $c] = "-";
    } else {
        @map[$r; $c] = "7";
    }
} else {
    @map[$r; $c] = "F";
}

# Erase the extraneous pipes to make it pretty
for @rc -> ($r, $c) {
    @map[$r; $c] = '.' unless $visited{"$r;$c"};
}

say @map».join("").join("\n");

my $area = 0;
for @map.keys -> $r {
    my $inside = False;
    for @map[$r].kv -> $c, $sym {
        if $sym (elem) ('|', 'L', 'J') {
            $inside = !$inside;
        }
        if $sym eq '.' and $inside {
            $area++;
        }
    }
}
say $area;
