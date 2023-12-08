my @directions = $*ARGFILES.get.comb;
$ = $*ARGFILES.get;
my %map;
for $*ARGFILES.lines -> $line {
    $line ~~ /(...) ' = (' (...) ', ' (...) ')'/;
    %map{$0}<L> = $1;
    %map{$0}<R> = $2;
}

my @starts = %map.keys.grep: { $_ ~~ /'A' $/ };
say [lcm] gather {
    for @starts -> $pos is copy {
        say "starting at $pos";
        my ($i, $steps) = (0, 0);
        loop {
            if $pos ~~ /'Z' $/ {
                say "took $steps steps";
                take $steps;
                last;
            }
            my $dir = @directions[$i];
            $pos = %map{$pos}{$dir};
            $i = ($i + 1) % @directions.elems;
            $steps++;
        }
    }
};
