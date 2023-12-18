use Array::Sorted::Util;

my @map = $*ARGFILES.lines».comb».Int;

my @DIRS = (
    (1, 0),
    (-1, 0),
    (0, 1),
    (0, -1),
);

my @queue = (
    # dir (0, 0) doesn't match anything so we can go three steps
    # in any direction from the start, theoretically.
    { loss => 0, pos => (0, 0), dir => (0, 0), straight => 0, key => "init" },
);

my %visited;

my $i = 1;
while my $state = @queue.shift {
    next if %visited{$state<key>}:exists;
    %visited{$state<key>} = $state<loss>;

    my $goal = $state<pos> eqv (@map.end, @map[0].end);
    if $goal or $i++ % 100 == 0 {
        say "[$state<pos>]: $state<loss> (elems: { @queue.elems })";
    }
    last if $goal;

    for @DIRS -> $dir {
        my $newpos = $state<pos> «+» $dir;
        next if any($state<path>) eqv $newpos;

        next if $newpos[0] < 0 or $newpos[0] > @map.end;
        next if $newpos[1] < 0 or $newpos[1] > @map[0].end;
        next if $dir eqv ($state<dir> «*» -1);
        my $straight = ($dir eqv $state<dir>) ?? $state<straight> + 1 !! 1;
        next if $straight == 4;
        my $loss = $state<loss> + @map[$newpos[0]; $newpos[1]];
        my $data = { 
            key => $newpos.join(";") ~ ";" ~ $dir.join(";") ~ ";$straight",
            loss => $loss,
            pos => $newpos,
            dir => $dir,
            straight => $straight,
        };
        inserts(@queue, $data, :cmp({ $^a<loss> <=> $^b<loss> || $^a<key> cmp $^b<key> }));
    }
}
