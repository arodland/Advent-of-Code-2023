my $pat = rx/\d|one|two|three|four|five|six|seven|eight|nine/;
my $revpat = rx/\d|eno|owt|eerht|ruof|evif|xis|neves|thgie|enin/;

my %map = one => 1, two => 2, three => 3, four => 4, five => 5, six => 6, seven => 7, eight => 8, nine => 9;

my $sum = 0;

for $*ARGFILES.lines -> $line {
    my $first = $line ~~ $pat;
    my $last = ($line.flip ~~ $revpat).flip;
    $first = %map{$first} // $first;
    $last = %map{$last} // $last;
    my $num = 10*$first+$last;
    say $num;
    $sum += $num;
}
say $sum;
