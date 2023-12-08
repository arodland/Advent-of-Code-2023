my @directions = $*ARGFILES.get.comb;
$ = $*ARGFILES.get;
my %map;
for $*ARGFILES.lines -> $line {
    $line ~~ /(...) ' = (' (...) ', ' (...) ')'/;
    %map{$0}<L> = $1;
    %map{$0}<R> = $2;
}

my ($i, $steps, $pos) = (0, 0, 'AAA');
loop {
    say $pos;
    if $pos eq 'ZZZ' {
        say $steps;
        last;
    }
    my $dir = @directions[$i];
    $pos = %map{$pos}{$dir};
    $i = ($i + 1) % @directions.elems;
    $steps++;
}
