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
        take ($r-1, $c) if $r > 0 and @map[$r-1; $c] (elem) ('|', '7', 'F');
        take ($r+1, $c) if $r < @map.elems-1 and @map[$r+1; $c] (elem) ('|', 'J', 'L');
        take ($r, $c-1) if $c > 0 and @map[$r; $c-1] (elem) ('-', 'F', 'L');
        take ($r, $c+1) if $c < @map[0].elems-1 and @map[$r; $c+1] (elem) ('-', '7', 'J');
    }
    @neighbors = @neighbors.grep: { !$visited{$_.join(";")} };
    for @neighbors -> $n {
        @queue.push([$n, $dist+1]);
    }
}

say $maxdist;
