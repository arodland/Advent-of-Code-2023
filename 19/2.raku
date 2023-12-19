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
    }
}

my $accepted = 0;
my @queue = (
    [ 'in', { x => 1..4000, m => 1..4000, a => 1..4000, s => 1..4000 } ],
);

PART: while @queue.elems {
    my ($wfname, $bounds) = @queue.shift;
    my @wf = %rules{$wfname}.clone;
    RULE: while @wf.elems {
        my $rule = @wf.shift;
        my $cond = $rule<cond>;
        my $newbounds = { x => $bounds<x>.clone, m => $bounds<m>.clone, a => $bounds<a>.clone, s => $bounds<s>.clone };
        if $cond.defined and $cond[1] eq '>' {
            $newbounds{$cond[0]} = ($newbounds{$cond[0]}.min max $cond[2]+1) .. $newbounds{$cond[0]}.max;
            $bounds{$cond[0]} = $bounds{$cond[0]}.min .. ($bounds{$cond[0]}.max min $cond[2]);
        } elsif $cond.defined and $cond[1] eq '<' {
            $newbounds{$cond[0]} = $newbounds{$cond[0]}.min .. ($newbounds{$cond[0]}.max min $cond[2]-1);
            $bounds{$cond[0]} = ($bounds{$cond[0]}.min max $cond[2]) .. $bounds{$cond[0]}.max;
        }
        if $rule<dest> eq 'A' {
            $accepted += [*] $newbounds.values».elems;
        }
        elsif $rule<dest> ne 'R' and none($newbounds.values».elems) == 0 {
            @queue.push: [ $rule<dest>, $newbounds ];
        }
        last RULE if any($bounds.values».elems) == 0;
    }
}

say $accepted;

