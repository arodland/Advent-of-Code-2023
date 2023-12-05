my @vals;
my @newvals;

for $*ARGFILES.lines -> $line {
    if $line ~~ /'seeds:' \s+ (.*)/ {
        @vals = $0.words».Int;
    } elsif $line ~~ /(\w+) '-to-' (\w+) \s+ 'map:'/ {
        # don't think we need to do anything with this
    } elsif $line ~~ /\d/ {
        my ($to, $from, $span) = $line.words».Int;
        my $range = $from ..^ ($from+$span);
        my $diff = ($to - $from);

        my %cat = @vals.categorize({ $^a ~~ $range });
        @vals = |(%cat{False} || ());
        @newvals.append(|(%cat{True} «+» $diff)) if %cat{True}:exists;
    } else { # blank line, end of a transformation group
        @vals.append(@newvals);
        @newvals = ();
    }
}

@vals.append(@newvals);
say @vals.min;
