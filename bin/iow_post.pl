#!/usr/bin/perl

### IOW Post Processing

$IOW_GEN_RESULT_FILE = ""; 
$IOW_MAPPED_CORPUS_FILE = "";
$IOW_CORPUS_MAP_FILE = "";
$IOW_FILL_NUM = "";
$IOW_FILL_METHOD = "";

## Default Settings
$IOW_FILL_METHOD = "vary";

## Read Command Line Arguments
for($i=0; $i <= $#ARGV; $i++) {
	if($ARGV[$i] eq "-vmrs-result-file") {
		$IOW_GEN_RESULT_FILE = $ARGV[++$i];
		print STDERR "Setting Gen Result File to: $IOW_GEN_RESULT_FILE\n";
	} elsif($ARGV[$i] eq "-corpus-map-file") {
		$IOW_CORPUS_MAP_FILE = $ARGV[++$i];
		print STDERR "Setting Corpus Map File to: $IOW_CORPUS_MAP_FILE\n";
	} elsif($ARGV[$i] eq "-mapped-corpus-file") {
		$IOW_MAPPED_CORPUS_FILE = $ARGV[++$i];
		print STDERR "Setting Mapped Corpus File to: $IOW_MAPPED_CORPUS_FILE\n";
	} elsif($ARGV[$i] eq "-fill-num") {
		$IOW_FILL_NUM = $ARGV[++$i];
		print STDERR "Setting Fill Num to: $IOW_FILL_NUM\n";
	} elsif($ARGV[$i] eq "-fill-method") {
		$IOW_FILL_METHOD = lc($ARGV[++$i]);
		print STDERR "Setting Fill Method to: $IOW_FILL_METHOD\n";
	} else {
		print STDERR "iow_post: Aborting due to erroneous argument: $ARGV[$i]\n";
		die "Valid parameters are:\n\t-vmrs-result-file\n\t-corpus-map-file\n\t-mapped-corpus-file\n\t-fill-num\n\t-fill-method\n";
	}
}

my @IOW_CORPUS_SENTENCE = (); ## An array of sentences
my %IOW_CORPUS_MAP = ();
my %IOW_GEN_RESULT = (); ## A hash of hashes, the first key is the id, the second key is the sentence, stored value is the duplicate count

## Open the temp file for processing

### Build Corpus Map Hash
die "Corpus Map File doesn't exist.\n" unless -e $IOW_CORPUS_MAP_FILE;
open CM, "< $IOW_CORPUS_MAP_FILE" or die "iow_post: Can't open corpus map file. $!";
while (<CM>) {
chomp;
/([0-9]+)\t([0-9]+)/;
#print STDERR "Mapping $1 to $2\n";
$IOW_CORPUS_MAP{$2} = $1; 
}
close CM;

### Build Corpus Sentence Array -- Assume IDs start at 1
die "Mapped Corpus File doesn't exist.\n" unless -e $IOW_MAPPED_CORPUS_FILE;
open CMM, "< $IOW_MAPPED_CORPUS_FILE" or die "iow_post: Can't open mapped corpus file. $!";
while (<CMM>) {
	chomp;
	/\[([0-9]+)\] (.+)/;
	#print STDERR "Mapping sentence $2 to $1\n";
	$IOW_CORPUS_SENTENCE[$1] = $2; 
}
close CMM;

## Build Generation Result Hash
die "Generation Result File doesn't exist.\n" unless -e $IOW_GEN_RESULT_FILE;
open GENR, "< $IOW_GEN_RESULT_FILE" or die "iow_post: Can't open generation result file. $!";
%dups = ();
while(<GENR>) {
 chomp;
($id, $sent) = split /@/;

## Need to check duplicates and keep order
	if(!$dups{"$id$sent"}++) {
		# print STDERR "Adding $sent to $id.\n";
		push(@{$IOW_GEN_RESULT{$id}},$sent);
	} else {
		#print "Skipping duplicate.\n";
	}
}
close GENR;

#print "####\n";

## Write out result with appropriate fill-in method
for($i=1; $i <= $#IOW_CORPUS_SENTENCE; $i++) {
	# print STDERR "i is $i\n";	
	$GEN_RESULT_COUNT = scalar @{$IOW_GEN_RESULT{$i}}; ## Does it give 0 when there is none?
	print "$IOW_CORPUS_MAP{$i}\t0\t$IOW_CORPUS_SENTENCE[$i]\n"; ## Printing original sentence
	next if($GEN_RESULT_COUNT == 0);	
	$FULL_FILLS = int $IOW_FILL_NUM/$GEN_RESULT_COUNT;
	$REMAINDER = $IOW_FILL_NUM%$GEN_RESULT_COUNT;
	$TOTAL_FILLS = ($FULL_FILLS-1)*$GEN_RESULT_COUNT+$REMAINDER;
        # print STDERR "Total Fills is: $TOTAL_FILLS\n";
		
	$j=0;	
	for(; $j < $GEN_RESULT_COUNT; $j++) {
		print $IOW_CORPUS_MAP{$i} . "\t" . ($j+1) . "\t" . ${$IOW_GEN_RESULT{$i}}[$j] . "\n";
	}
	if($IOW_FILL_METHOD eq "vary") {
	} elsif($IOW_FILL_METHOD eq "distrib") {
		for(;$TOTAL_FILLS > 0;) {
			for($k=0; $k < $GEN_RESULT_COUNT && $TOTAL_FILLS > 0; $k++, $TOTAL_FILLS--) {
				print $IOW_CORPUS_MAP{$i} . "\t" . (++$j) . "\t" . ${$IOW_GEN_RESULT{$i}}[$k] . "\n";			
			}
		}
	} elsif($IOW_FILL_METHOD eq "first") {
		for(; $TOTAL_FILLS > 0; $TOTAL_FILLS--) {
				print $IOW_CORPUS_MAP{$i} . "\t" . (++$j) . "\t" . ${$IOW_GEN_RESULT{$i}}[0] . "\n";			
			}
	}
}

