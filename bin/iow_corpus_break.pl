#!/usr/bin/perl

### IOW Corpus Break-Up Script

## This script breaks a huge corpus file into segments of length N based on the user's parameters, it also remaps the corpus ids to integer values
## assuming the segment length is also an integer length

## Produces output files of the form $IOW_CORPUS_FILE.part{N} where {N} is a number start with 0

$IOW_CORPUS_FILE = "";
$IOW_SEGMENT_LENGTH = "";

## Default Settings
$IOW_SEGMENT_LENGTH = 2000;

## Read Command Line Arguments
for($i=0; $i <= $#ARGV; $i++) {
	if($ARGV[$i] eq "-corpus-file") {
		$IOW_CORPUS_FILE = $ARGV[++$i];
		print STDERR "iow_corpus_break: Setting Corpus File to: $IOW_CORPUS_FILE\n";
	} elsif($ARGV[$i] eq "-segment-length") {
		$IOW_SEGMENT_LENGTH = $ARGV[++$i];
		print STDERR "iow_corpus_break: Setting Segment Length to: $IOW_SEGMENT_LENGTH\n";
	} else {
		print STDERR "iow_corpus_break: Aborting due to erroneous argument: $ARGV[$i]\n";
		die "Valid parameters are:\n\t-corpus-file\n\t-segment-length\n";
	}
}

## Break up the Corpus
die "iow_corpus_break: Corpus file doesn't exist.\n" unless -e $IOW_CORPUS_FILE;

$CORPUS_SIZE = `wc -l < $IOW_CORPUS_FILE`;

$NUM_PARTS = (int $CORPUS_SIZE / $IOW_SEGMENT_LENGTH) + (((int $CORPUS_SIZE % $IOW_SEGMENT_LENGTH) > 0) ? 1 : 0);

$CURRENT_POS=$IOW_SEGMENT_LENGTH;

for($i=0; $i < $NUM_PARTS; $i++) {
	if ($i+1 == $NUM_PARTS) {
		$LAST_BIT = int $CORPUS_SIZE % $IOW_SEGMENT_LENGTH;
		`head -$CURRENT_POS $IOW_CORPUS_FILE | tail -$LAST_BIT > $IOW_CORPUS_FILE.part$i`;
 	} else {
		`head -$CURRENT_POS $IOW_CORPUS_FILE | tail -$IOW_SEGMENT_LENGTH > $IOW_CORPUS_FILE.part$i`;
 	}
	$CURRENT_POS+=$IOW_SEGMENT_LENGTH;
}

## Re-Map Parts Files

for($i=0; $i < $NUM_PARTS; $i++) {
	$newID=1;	
	`rm -rf $IOW_CORPUS_FILE.part$i.map $IOW_CORPUS_FILE.part$i.mapped`;
	open CF, "< $IOW_CORPUS_FILE.part$i" or die "iow_corpus_break: Can't open corpus part file. $!";
	while (<CF>) {
		chomp;
		/\[([^\]]+)\] (.+)/;
		`echo "$1\t$newID" >> $IOW_CORPUS_FILE.part$i.map`;
		`echo "[${newID}] $2" >> $IOW_CORPUS_FILE.part$i.mapped`;
		$newID++;
	}
	close CF;
}

print $NUM_PARTS;

