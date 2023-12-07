my %cardvals = <J 2 3 4 5 6 7 8 9 T Q K A>.antipairs;

sub classify(@hand) {
    my $jacks = @hand.grep({ $_ eq 'J' }).elems;
    my @nonjacks = @hand.grep({ $_ ne 'J' });

    return 7 if $jacks >= 4;

    my @pairs = Bag(@nonjacks).sort: { $^b.value <=> $^a.value };
    if @pairs[0].value + $jacks == 5 {
        return 7;
    } elsif @pairs[0].value + $jacks == 4 {
        return 6;
    } elsif @pairs[0].value + $jacks == 3 && @pairs[1].value == 2 {
        return 5;
    } elsif @pairs[0].value + $jacks == 3 {
        return 4;
    } elsif @pairs[0].value + $jacks == 2 && @pairs[1].value == 2 {
        return 3;
    } elsif @pairs[0].value + $jacks == 2 {
        return 2;
    } else {
        return 1;
    }
}

sub handcmp(@a, @b) {
    my $class_cmp = classify(@a) <=> classify(@b);
    return $class_cmp if $class_cmp;
    my @cv_a = @a.map: { %cardvals{$_} };
    my @cv_b = @b.map: { %cardvals{$_} };
    return @cv_a cmp @cv_b;
}

my @hands;
for $*ARGFILES.lines -> $line {
    my ($hand, $bid) = $line.words;
    my @hand = $hand.comb;
    $bid = $bid.Int;
    my $class = classify(@hand);
    @hands.push({hand => @hand, bid => $bid, class => $class });
}

my @sorted = @hands.sort: { handcmp($^a<hand>, $^b<hand>) };
my $score = 0;

for @sorted.kv -> $rank, $hand {
    $score += ($rank+1) * $hand<bid>;
}
say $score;
