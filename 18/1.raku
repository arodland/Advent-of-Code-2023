my %DIRMAP := {
    'U' => (-1, 0),
    'D' => (1, 0),
    'L' => (0, -1),
    'R' => (0, 1),
};

my @pos = [0, 0];
my @map;

for $*ARGFILES.lines -> $line {
    $line ~~ /(<[UDLR]>) \s+ (\d+) \s+ '(#' (<xdigit> ** 6) ')'/;
    my ($dir, $steps, $color) = ($0.Str, $1.Int, $2.Str);
    say "$dir $steps $color";

    for 1..$steps {
        @pos = @pos «+» %DIRMAP{$dir};

        while @pos[0] < 0 {
            @map.unshift([]);
            @pos[0]++;
        }
        while @pos[1] < 0 {
            $_.unshift(' ') for @map;
            @pos[1]++;
        }

        @map[@pos[0]; @pos[1]] = '#';
    }
}

for @map -> $row {
    say $row.map({ $_ // ' '}).join;
}
say "";

my @queue = ([2,170],);
my %visited;
while @queue.elems {
    my ($r, $c) = @queue.shift;
    next if %visited{"$r;$c"}++;
    next if $r < 0 or $r > @map.end or $c < 0 or $c > @map[$r].end;

    @map[$r; $c] = '#';
    @queue.push([ $r-1, $c ]) unless (@map[$r-1; $c] // ' ') eq '#';
    @queue.push([ $r+1, $c ]) unless (@map[$r+1; $c] // ' ') eq '#';
    @queue.push([ $r, $c-1 ]) unless (@map[$r; $c-1] // ' ') eq '#';
    @queue.push([ $r, $c+1 ]) unless (@map[$r; $c+1] // ' ') eq '#';
}

for @map -> $row {
    say $row.map({ $_ // ' '}).join;
}

say sum @map[*;*] «eq» '#';
