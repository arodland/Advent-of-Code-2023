my $prod = 1;

$*ARGFILES.get ~~ /'Time:' \s+ (.*)/;
my @times = (S:g/\s+// given $0).words».Int;
$*ARGFILES.get ~~ /'Distance:' \s+ (.*)/;
my @distances = (S:g/\s+// given $0).words».Int;

for @times.kv -> $i, $time {
    my $distance = @distances[$i];
    my $x1 = ($time - sqrt($time*$time - 4*$distance)) / 2;
    my $x2 = ($time + sqrt($time*$time - 4*$distance)) / 2;
    my $lower = (min($x1, $x2) + 1).floor;
    my $upper = (max($x1, $x2) - 1).ceiling;
    $lower = 0 if $lower < 0;
    $upper = $time if $upper > $time;
    say "$lower - $upper";
    say 1 + $upper - $lower;
    $prod *= (1 + $upper - $lower);
}

say $prod;
