my @map = $*ARGFILES.lines».comb».Array;

my @state = (
    { pos => [0, -1], dir => [0, 1] },
);

my %visited;
my %illuminated;

while @state.elems {
    my @newst;
    for @state -> $st {
        my $key = $st<pos>.join(";") ~ ";" ~ $st<dir>.join(";");
        next if %visited{$key}++;

        my $pos = $st<pos> «+» $st<dir>;
        next if $pos[0] < 0 or $pos[0] > @map.end or $pos[1] < 0 or $pos[1] > @map[0].end;
        %illuminated{ $pos.join(";") } = 1;
        my $sym = @map[$pos[0]; $pos[1]];
        given $sym {
            when '\\' {
                @newst.push: { pos => $pos, dir => [ $st<dir>[1], $st<dir>[0] ] };
            }
            when '/' {
                @newst.push: { pos => $pos, dir => [ -$st<dir>[1], -$st<dir>[0] ] };
            }
            when '|' {
                if $st<dir>[1] != 0 {
                    @newst.push: { pos => $pos, dir => [ -1, 0 ] };
                    @newst.push: { pos => $pos, dir => [ 1, 0 ] };
                } else {
                    @newst.push: { pos => $pos, dir => $st<dir> };
                }
            }
            when '-' {
                if $st<dir>[0] != 0 {
                    @newst.push: { pos => $pos, dir => [ 0, -1 ] };
                    @newst.push: { pos => $pos, dir => [ 0, 1 ] };
                } else {
                    @newst.push: { pos => $pos, dir => $st<dir> };
                }
            }
            default {
                @newst.push: { pos => $pos, dir => $st<dir> };
            }
        }
    }
    say "count: ", %illuminated.elems;
    @state = @newst;
}
