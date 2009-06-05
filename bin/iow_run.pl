#!/usr/bin/perl

## Author: Scott Appling, darren.scott.appling@gmail.com
## Requirements: Ubuntu 8.22, Delphin Tools

## Purpose: Run the paraphrase system: 
## 1) Break Corpus Up, 2) Parse Corpus, 3) Generate New Paraphrase, 4) Reassemble Corpus

## TODO: Add a force option to overwrite existing work directories

### IOW Run

$IOW_GEN_RESULT_FILE = ""; 
$IOW_CORPUS_FILE = "";

## Default Settings
$IOW_PROFILE_DIRECTORY_NAME = "profile";
$IOW_FIRST_STAGE = 1;
$IOW_LAST_STAGE = 3;
$IOW_CPU_COUNT = 1;
$IOW_FILL_METHOD = "vary";
$IOW_FILL_NUM = 10;
$IOW_FORCE = false;
$IOW_TYPE = "erg";

## CPU Setting
$MAX_CPU=`cat /proc/cpuinfo | grep processor | wc -l`;
if($MAX_CPU > 1) {
	$MAX_CPU--;
}
$IOW_CPU_COUNT=$MAX_CPU;

## Read Command Line Arguments
for($i=0; $i <= $#ARGV; $i++) {
	if($ARGV[$i] eq "-corpus-file") {
		$IOW_CORPUS_FILE = $ARGV[++$i];
		print STDERR "Setting Corpus File to: $IOW_CORPUS_FILE\n";
		## Let's make a directory called called dirname $IOW_CORPUS_FILE/`basename $IOW_CORPUS_FILE`_work
	} elsif($ARGV[$i] eq "-profile-dir") {
		$IOW_PROFILE_DIRECTORY_NAME = $ARGV[++$i];
		print STDERR "Setting Profile Directory Name to: $IOW_PROFILE_DIRECTORY_NAME\n";
	} elsif($ARGV[$i] eq "-first-stage") {
		$IOW_FIRST_STAGE = $ARGV[++$i];
		print STDERR "Setting First Stage to: $IOW_FIRST_STAGE\n";
	} elsif($ARGV[$i] eq "-last-stage") {
		$IOW_LAST_STAGE = $ARGV[++$i];
		print STDERR "Setting Last Stage to: $IOW_LAST_STAGE\n";
	} elsif($ARGV[$i] eq "-max-cpu") {
		$IOW_CPU_COUNT = $ARGV[++$i];
		print STDERR "Setting CPU Count to: $IOW_CPU_COUNT\n";
	} elsif($ARGV[$i] eq "-fill-method") {
		$IOW_FILL_METHOD = $ARGV[++$i];
		print STDERR "Setting Fill Method to: $IOW_FILL_METHOD\n";
	} elsif($ARGV[$i] eq "-fill-num") {
		$IOW_FILL_NUM = $ARGV[++$i];
		print STDERR "Setting Fill Num to: $IOW_FILL_NUM\n";
	} elsif($ARGV[$i] eq "-system-type") {
		$IOW_TYPE = $ARGV[++$i];
		print STDERR "Setting system type to: $IOW_TYPE\n";
	} elsif($ARGV[$i] eq "-force") {
		$IOW_FORCE = true;
		print STDERR "Setting Force to: $IOW_FORCE\n";
	} else {
		print STDERR "Aborting due to erroneous argument: $ARGV[$i]\n";
		die "Valid parameters are:\n\t-corpus-file\n\t-profile-dir\n\t-fill-method\n\t-force\n";
	}
}

sub check_stage {
 my $stage = shift(@_);
 if($IOW_FIRST_STAGE <= $stage && $IOW_LAST_STAGE >= $stage) {
	print STDERR "Starting stage $stage...\n";
	return 1;
 } else {
	print STDERR "Skipping stage $stage.\n";
	return 0;
 }
}

sub run_erg {
	my $WORK_PART_DIR = shift(@_);
	print STERR "Running ERG...\n";

	print STDERR "Exec: logon_do -g enen -t smrs -l 1 -c $IOW_CPU_COUNT $WORK_PART_DIR\n";
	system("logon_do -g enen -t smrs -l 1 -c $IOW_CPU_COUNT $WORK_PART_DIR");
	
	print STDERR "Exec: logon_do -s " . $ENV{"DTHOME"} . "/lisp/settings/para_erg_gen.lisp -g enen -t vmrs -c $IOW_CPU_COUNT $WORK_PART_DIR\n";
	system("logon_do -s " . $ENV{"DTHOME"} . "/lisp/settings/para_erg_gen.lisp -g enen -t vmrs -c $IOW_CPU_COUNT $WORK_PART_DIR");
}

sub run_enen {
my $WORK_PART_DIR = shift(@_);
print STERR "Running EnEn...\n";

print STDERR "Exec: logon_do -g enen -t smrs -l 1 -c $IOW_CPU_COUNT $WORK_PART_DIR\n";
system("logon_do -g enen -t smrs -l 1 -c $IOW_CPU_COUNT $WORK_PART_DIR");
system("logon_do -s " . $ENV{"DTHOME"} . "/lisp/settings/enen_pmrs.lisp -g enen -t pmrs -c $IOW_CPU_COUNT $WORK_PART_DIR");
system("logon_do -s " . $ENV{"DTHOME"} . "/lisp/settings/enen_gpmrs.lisp -g enen -t gpmrs -c $IOW_CPU_COUNT $WORK_PART_DIR");
}

die "Corpus file doesn't exist." unless -e $IOW_CORPUS_FILE;

$CORPUS_FILE_PATH = `dirname $IOW_CORPUS_FILE`;
$CORPUS_FILE_NAME = `basename $IOW_CORPUS_FILE`;
chomp $CORPUS_FILE_NAME;
chomp $CORPUS_FILE_PATH;
$WORK_DIR = "$CORPUS_FILE_PATH/${CORPUS_FILE_NAME}_work";


if(check_stage(1)) {
if (-e $WORK_DIR) {
die "Please remove the directory $WORK_DIR before running this script again." if !$IOW_FORCE;
`rm -rf $WORK_DIR`;
}
print "Going to make $WORK_DIR\n";
`mkdir $WORK_DIR`;
`cp $IOW_CORPUS_FILE $WORK_DIR`;
die "IOW Corpus Break could not be found." unless -e "./iow_corpus_break.pl";
$NUM_PARTS = `./iow_corpus_break.pl -corpus-file $WORK_DIR/$CORPUS_FILE_NAME -segment-length 2000`;

}

if(check_stage(2)) {
## For Each Part Run the Delphin Tools Framework
for($cur_part=0; $cur_part < $NUM_PARTS; $cur_part++) {
	$WORK_PART_DIR = "${WORK_DIR}/${IOW_PROFILE_DIRECTORY_NAME}_${cur_part}";
	print STDERR "Making Directory: $WORK_PART_DIR\n";
	`mkdir $WORK_PART_DIR`;

	 print STDERR "Exec: logon_do -a $WORK_DIR/$CORPUS_FILE_NAME.part${cur_part}.mapped $WORK_PART_DIR\n";
	system("logon_do -a $WORK_DIR/$CORPUS_FILE_NAME.part${cur_part}.mapped $WORK_PART_DIR");
	run_erg($WORK_PART_DIR) if $IOW_TYPE eq "erg";
	run_enen($WORK_PART_DIR) if $IOW_TYPE eq "enen";
}
}

if(check_stage(3)) {
die "iow_post could not be found." unless -e "./iow_post.pl";
## Time To Collect All The Results from VMRS
$cur_part=0;
$WORK_PART_BASE_PATH = "${WORK_DIR}/${IOW_PROFILE_DIRECTORY_NAME}";
while(-e "${WORK_PART_BASE_PATH}_${cur_part}" && -d "${WORK_PART_BASE_PATH}_${cur_part}") {
	$WORK_PART_DIR = "${WORK_PART_BASE_PATH}_${cur_part}";
	$PART_FULL_PATH = "${WORK_DIR}/${CORPUS_FILE_NAME}.part${cur_part}";
## Prune Duplicates to Temp File
`cut -d@ -f1,13 $WORK_PART_DIR/gpmrs/?/?/result >> $WORK_DIR/$CORPUS_FILE_NAME.part$cur_part.mapped.gpmrs.result`;
print "./iow_post.pl -vmrs-result-file ${PART_FULL_PATH}.mapped.gpmrs.result -corpus-map-file ${PART_FULL_PATH}.map -mapped-corpus-file ${PART_FULL_PATH}.mapped -fill-num ${IOW_FILL_NUM} -fill-method ${IOW_FILL_METHOD} >> ${WORK_DIR}/${CORPUS_FILE_NAME}.result";
`./iow_post.pl -vmrs-result-file ${PART_FULL_PATH}.mapped.gpmrs.result -corpus-map-file ${PART_FULL_PATH}.map -mapped-corpus-file ${PART_FULL_PATH}.mapped -fill-num ${IOW_FILL_NUM} -fill-method ${IOW_FILL_METHOD} >> ${WORK_DIR}/${CORPUS_FILE_NAME}.result`;
$cur_part++;
}
}
