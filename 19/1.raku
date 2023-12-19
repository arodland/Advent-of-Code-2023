my %rules;
my @parts;

for $*ARGFILES.lines -> $line {
    if $line ~~ /^ (\w+) '{' (.+) '}' $/ {
        my $name = $0.Str;
        my @rules = $1.Str.split(',').map: -> $rule {
            $rule ~~ /[ (\w+) ('<' || '>') (\d+) ':' ]? (\w+)/;
            {
                cond => ($0.defined ?? [ $0.Str, $1.Str, $2.Int ] !! Nil),
                dest => $3.Str,
            }
        }
        %rules{$name} = @rules;
    } elsif $line ~~ /^ '{' (.+) '}' $/ {
        @parts.push: Hash($0.Str.split(',')».split('=').flat);
    }
}

my $total;
PART: for @parts -> $part {
    say "Part: ", $part;
    say "Begin with in";
    my @wf = %rules<in>.clone;
    RULE: loop {
        my $rule = @wf.shift;
        say "Rule: ", $rule;
        my $cond = $rule<cond>;
        if $cond.defined and $cond[1] eq '>' {
            next RULE unless $part{ $cond[0] } > $cond[2];
        }
        if $cond.defined and $cond[1] eq '<' {
            next RULE unless $part{ $cond[0] } < $cond[2];
        }
        if $rule<dest> eq 'R' {
            say "Reject";
            next PART;
        }
        if $rule<dest> eq 'A' {
            say "Accept";
            $total += [+] $part.values;
            next PART;
        }
        say "Jump to $rule<dest>";
        @wf = %rules{$rule<dest>}.clone;
    }
}

say $total;

