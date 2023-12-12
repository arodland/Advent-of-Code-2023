# Star 1: raku combined.raku 1 input.txt
# Star 2: raku combined.raku 5 input.txt

my $REPLICATE = @*ARGS.shift.Int;

# Read each line of the input and aggregate the total possibilities.
# .race allows processing several lines in parallel for a speedup.
my $total = [+] $*ARGFILES.lines.race.map: -> $line {
my $total = [+] $*ARGFILES.lines.race(:batch(1)).map: -> $line {
    # Input parsing
    my ($springs_orig, $target_orig) = $line.words;
    my $springs = ($springs_orig xx $REPLICATE).join('?');
    my $target = ($target_orig xx $REPLICATE).join(',');
    $target = $target.split(',')».Int.Array;

    # State is stored as a list of pairs: the value is a list of group sizes
    # (with a terminating 0 if we've seen a dot after the last group)
    # and the key is the number of ways we've found to make that grouping.
    # Initially, there is one way to make nothing.
    my @product = [ 1 => [0] ];

    # Read each character of the (replicated) spec and update @product accordingly.
    for $springs.comb -> $ch {
        given $ch {
            when '.' {
                # The lengths of strings of dots don't matter, just make sure all states have at least
                # one zero at the end.
                for @product {
                    $_.value.push(0) unless $_.value.tail == 0;
                }
            }
            when '#' {
                # Increment the # count at the end of each state (turning 0 into 1 if appropriate).
                $_.value.tail++ for @product;
            }
            when '?' {
                # Replicate the list and do both things: add a . to one copy and a # to the other.
                my $last = @product.end;
                for 0 .. $last -> $i {
                    my $p := @product[$i];
                    my $v = $p.value.clone;
                    $v.push(0) unless $v.tail == 0;
                    @product.push($p.key => $v);
                    $p.value.tail++;
                }
                # Some elements might have identical group lists now. Find them and merge them into
                # a single entry with the sum of their counts.
                @product = @product.classify(*.value.join(',')).values.map: { ([+] $_».key) => $_[0].value };
            }
        }
        # Prune any groupings that couldn't become the target by further appending.
        # Ignoring a possible ending zero, all elements except the last should equal corresponding
        # elements of the target, and the last should be less than or equal to the corresponding
        # element of the target.
        @product .= grep: {
            my $v := $_.value;
            my $end = ($v.tail == 0 && $v.elems > 1) ?? $v.end-1 !! $v.end;
            ($end <= $target.end) &&
            ($v[0 .. $end-1] eqv $target[0 .. $end-1]) && 
            ($v[$end] <= $target[$end])
        };
    }

    # Done processing input. Clean up trailing zeroes.
    for @product {
        $_.value.pop if $_.value.elems > 0 and $_.value.tail == 0;
    }

    # Add up the counts of matching items. If the previous code worked properly,
    # there should be no more than two matches: one which had a trailing zero removed just now
    # and one that didn't have one to remove because a group ended at the end.
    my $count = [+] @product.grep({$_.value eqv $target }).map({$_ ?? .key !! 0});
    say "$springs_orig ($target_orig) == $count";
    $count;
};

say $total;
