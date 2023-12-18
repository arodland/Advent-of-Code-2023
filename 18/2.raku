my %DIRMAP := {
    '3' => (-1, 0),
    '1' => (1, 0),
    '2' => (0, -1),
    '0' => (0, 1),
};

my @pos = [0, 0];
my $volume = 1; # The initial space

for $*ARGFILES.lines -> $line {
    $line ~~ /'(#' (<xdigit> ** 5) (<xdigit>) ')'/;
    my $steps = $0.Str.parse-base(16);
    my $dir = $1.Str;

    say "$dir $steps";

    my @prev = @pos.clone;
    @pos = @pos «+» ($steps «*» %DIRMAP{$dir});
    $volume += (@pos[0] * @prev[1] - @pos[1] * @prev[0] + $steps) / 2;
}

say abs($volume);
