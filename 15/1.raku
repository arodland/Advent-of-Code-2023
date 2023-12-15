sub hash(Str $str) {
    my $hash = 0;
    for $str.comb -> $ch {
        $hash = (($hash + $ch.ord) * 17) % 256;
    }
    return $hash;
}

my @instructions = $*ARGFILES.get.split(',');
say [+] @instructions.map(&hash);

        
