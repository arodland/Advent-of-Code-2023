my %cardvals = <2 3 4 5 6 7 8 9 T J Q K A>.antipairs;

sub classify(@hand) {
    my @pairs = Bag(@hand).sort: { $^b.value <=> $^a.value };
    if @pairs[0].value == 5 {
        return 7;
    } elsif @pairs[0].value == 4 {
        return 6;
    } elsif @pairs[0].value == 3 && @pairs[1].value == 2 {
        return 5;
    } elsif @pairs[0].value == 3 {
        return 4;
    } elsif @pairs[0].value == 2 && @pairs[1].value == 2 {
        return 3;
    } elsif @pairs[0].value == 2 {
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
