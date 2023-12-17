sub hash(Str $str) {
    (0, |$str.comb).reduce: { (($^a + $^b.ord) * 17) % 256 };
}

my @instructions = $*ARGFILES.get.split(',');
my @boxes;
for @instructions -> $inst {
    $inst ~~ / (\w+) [ ('=') (\d+) || ('-') ] /;
    my ($label, $op, $fl) = ($0.Str, $1.Str, $2);

    my $hash = hash($label);
    @boxes[$hash] //= [];
    my @box := @boxes[$hash];

    if ($op eq '-') {
        @box .= grep: { $_[0] ne $label };
    } elsif ($op eq '=') {
        if ((my $i = @box.first({ $_[0] eq $label }, :k)).defined) {
            @box[$i][1] = $fl.Int;
        } else {
            @box .= grep: { $_[0] ne $label };
            @box.push: [ $label, $fl.Int ];
        }
    }
}

my $power = 0;
for @boxes.kv -> $i, $box {
    next unless $box && $box.elems;
    for $box.kv -> $j, $lens {
        $power += ($i+1) * ($j+1) * $lens[1];
    }
}

say $power;
