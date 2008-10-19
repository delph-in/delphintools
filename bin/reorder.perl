#!/usr/bin/perl
$/ = "\n\n";

open(JAEN,  "tanaka-train-jaen.txt");

my %je = ();
my %length;

while (<JAEN>) {
    chomp;
    my ($ja, $en) = split /\n/;
    #print "$ja\n";
    if (defined $je{$ja}) {
    print "Two translations for $ja\n\t$je{$ja}\n\t$en\n";
    } else {
    $je{$ja} = $en;
    $length{$ja} = scalar split / /, $ja;
    }
}


my $dir = "len";
my $count = 0;
my $set = 0;



for my $ja (sort
        {($length{$a}) <=> ($length{$b})
        || reverse($a) cmp reverse($b)
        || reverse($je{$a}) cmp reverse ($je{$b}) }
        keys %je) {
    if ($count % 1000 == 0) {
	$num = sprintf "%03d", $set;
	open (OUT, ">$dir/tc-$num.jaen");
	print OUT ";;;\n;;; Tanaka Corpus;  Set $set; length ≧ $length{$ja}\n;;;\n";
	$set++;
    }
    $count++;
    print OUT "$ja\n$je{$ja}\n\n";
}

