#!/usr/bin/perl
#
# compre two fan files, or summarize just one
#  - shows sentences whose translation changed: # translations OR best translation
#   - lost translations are shown with -XXX-
#   - newly translated are shown with -xxx-
#  - final summary shows time taken, who ran the file and the fan summary
#
#  logon/nict/bin/readfan.perl   ja2en.tanaka-dev-001-jaen.08-09-{12,29}.fan
#
my ($gold, $target) = @ARGV;

my %res = ();
my %info = ();

for my $file ($gold, $target) {
    if ($file) {
	print STDERR "Processing $file\n";
	open (FILE, $file) || die "can't open $file\n";
	my $id = "";
	my $start = "";
	while (<FILE>) {
#    print;
#    if(m/\|< \|(今年 は 数 回 ここ に 来 て いる 。)\| \((\d+)\) --- (\d+) x (\d+) x (\d+) = (\d+)/) {
    if(m/\|< \|(.*)\| \((\d+)\) --- (\d+) x (\d+) x (\d+) = (\d+)/) {
       my $src = $1;
       $id = $2;
       my $parse = $3;
       my $xfer = $4;
      my $gen = $5;
      my $trans = $6;
    #print join "\t", $id, $trans, $parse, $xfer, $gen, $src;
    #print "\n"
      $res{$id}{$file}{"mt"} = $trans;
      $res{$id}{$file}{"src"} = $src;
    } elsif (m/\|> \|(.*)\|/ && not defined $res{$id}{$file}{"out"} ) {
    #print "$id\t$1\n";
      $res{$id}{$file}{"out"} = $1;
    } elsif (m/\|@ \|(.*)\|/ && not defined $res{$id}{$file}{"out"} ) {
    #print "$id\t$1\n";
      $res{$id}{$file}{"ref"} = $1;
    } elsif (m/^;;; fan-out batch \((.*); (.*) \((.*) h\)\)/) {
      my ($hour, $minute) = split /[:]/, $3; 
      $start = 60 * $hour + $minute;
      #print "START: $1\t$2\t$3\t($start)\n";
      $info{$file}{"who"} = $1;
      $info{$file}{"date"} = $2;
      $info{$file}{"start"} = $start;
    } elsif (m/^\[(.*?)]/) {
      my ($hour, $minute, $second) = split /[:]/, $1;
      my $end = 60 * $hour + $minute;
      my $diff = $end - $start;
      if ($diff < 0) { $diff += 1440}; # (* 60 24)　1440  assume only one day!
          $info{$file}{"diff"} = $diff;
    } elsif  (m/^\|=\s+(.*)\.$/) {
          $info{$file}{"sum"} = $1;
    }
  }
 }
}

if ($target) {
    for my $id (sort {$a <=> $b } keys %res) {
	if ( $res{$id}{$gold}{"mt"} != $res{$id}{$target}{"mt"}
	     || $res{$id}{$gold}{"out"} != $res{$id}{$target}{"out"}
) {
	    print join "\t",
	    $id.":",
	    $res{$id}{$gold}{"mt"},
	    $res{$id}{$target}{"mt"},
	    $res{$id}{$gold}{"src"},
	    $res{$id}{$gold}{"out"} || "-xxx-",
	    $res{$id}{$target}{"out"} || "-XXX-",
	    $res{$id}{$gold}{"ref"};
	    print "\n";
	}
    }
}
#
# $summarize
#
for my $file ($gold, $target) {
    if ($file) {
    print "\n$file\n";
    print "\t".$info{$file}{"who"}." at ".$info{$file}{"date"}."\n";
    print "\t".$info{$file}{"diff"}." minutes\n";
    print "\t".$info{$file}{"sum"}."\n";
    }
}
