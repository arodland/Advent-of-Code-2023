# Define set-intersect, set-difference, and bool-coerce operations on ranges.
# This naively assumes that all ranges are excludes-max and !excludes-min.
multi sub infix:<(&)>(Range:D $a, Range:D $b) {
    max($a.min, $b.min) ..^ min($a.max, $b.max);
}

multi sub infix:<(-)>(Range:D $a, Range:D $b) {
    return gather {
        if $a.min < $b.min {
            take $a.min ..^ $b.min;
        }
        if $a.max > $b.max {
            take $b.max ..^ $a.max;
        }
    }
}

multi sub prefix:<?>(Range:D $r) {
    $r.max > $r.min;
}

my @vals;
my @newvals;

for $*ARGFILES.lines -> $line {
    if $line ~~ /'seeds:' \s+ (.*)/ {
        @vals = $0.words».Int.rotor(2).map: { $_[0] ..^ $_[0]+$_[1] };
    } elsif $line ~~ /(\w+) '-to-' (\w+) \s+ 'map:'/ {
        # don't think we need to do anything with this
    } elsif $line ~~ /\d/ {
        my ($to, $from, $span) = $line.words».Int;
        my $range = $from ..^ ($from+$span);
        my $diff = ($to - $from);

        # Sort the seed ranges into ones that intersect with a transform-range and
        # ones that don't.
        my %cat = @vals.classify({ ?($_ (&) $range) });
        # The ones that don't go right back into @vals.
        @vals = |(%cat{False} || ());
        # For the ones that do:
        for |(%cat{True} || ()) -> $hunk {
            # Find the extent of the intersection
            my $intersection = $hunk (&) $range;
            # Shift it by as much as necessary and send it to the next stage.
            @newvals.push($intersection + $diff);
            # Whatever parts of the seed-range didn't intersect this transform-range go
            # back to @vals to possibly match a new transform-range.
            @vals.append($hunk (-) $intersection);
        }
    } else { # blank line, end of a transformation group
        # @vals for the next step is @newvals (the transformation output) plus whatever
        # elements of the old @vals didn't get touched by any transformations.
        @vals.append(@newvals);
        # And clear the output, of course.
        @newvals = ();
    }
}

@vals.append(@newvals);
say @vals.min.min;
