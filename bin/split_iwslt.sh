#!/bin/bash

rm -rf split && mkdir -p split

# get source sentences from LOGON ascii format bitext file
bitext2src () {
	awk '
	BEGIN {
		FS="\n"
		RS="\n\n"
	}
	{
		print $1
	}'
}

# get target sentences from LOGON ascii format bitext file
bitext2tgt () {
	awk '
	BEGIN {
		FS="\n"
		RS="\n\n"
	}
	{
		print $2
	}'
}

mecab8 () {
	iconv -c -s -f UTF-8 -t EUC-JP |
	mecab $* |
	iconv -c -s -f EUC-JP -t UTF-8
}

retok_ja () {
	tr -d ' ' |
	mecab8 -Owakati
}

retok () {
	paste -d "\\\\" <(cut -d\\ -f1 $1) <(cut -d\\ -f2- $1 | retok_ja)
}

echo -n "Splitting sentences and reformatting training data ..."
iwslt2ascii <(retok IWSLT06_JE_training_J.UTF-8.txt) IWSLT06_JE_training_E.UTF-8.txt \
			> split/IWSLT06_JE_training.comments.txt
grep -Ev "^#" split/IWSLT06_JE_training.comments.txt > split/IWSLT06_JE_training.ascii.txt
bitext2src < split/IWSLT06_JE_training.ascii.txt > split/IWSLT06_JE_training_J.txt
bitext2tgt < split/IWSLT06_JE_training.ascii.txt > split/IWSLT06_JE_training_E.txt
echo " done."

echo -n "Splitting sentences and reformatting development data ..."
cat IWSLT06_JE_devset*_J.UTF-8.txt > IWSLT06_JE_dev_J.UTF-8.txt
cat IWSLT06_JE_devset*_E.UTF-8.txt IWSLT06_JE_devset4_E.case+punc.UTF-8.txt > IWSLT06_JE_dev_E.UTF-8.txt
iwslt2ascii <(retok IWSLT06_JE_dev_J.UTF-8.txt) IWSLT06_JE_dev_E.UTF-8.txt > split/IWSLT06_JE_dev.comments.txt
grep -Ev "^#" split/IWSLT06_JE_dev.comments.txt > split/IWSLT06_JE_dev.ascii.txt
bitext2src < split/IWSLT06_JE_dev.ascii.txt > split/IWSLT06_JE_dev_J.txt
bitext2tgt < split/IWSLT06_JE_dev.ascii.txt > split/IWSLT06_JE_dev_E.txt
echo " done."

echo -n "Splitting sentences and reformatting test data ..."
iwslt2ascii <(retok IWSLT06_JE_testset_J.UTF-8.txt) IWSLT06_JE_testset_E.case+punc.UTF-8.txt \
		    > split/IWSLT06_JE_test.comments.txt
grep -Ev "^#" split/IWSLT06_JE_test.comments.txt > split/IWSLT06_JE_test.ascii.txt
bitext2src < split/IWSLT06_JE_test.ascii.txt > split/IWSLT06_JE_test_J.txt
bitext2tgt < split/IWSLT06_JE_test.ascii.txt > split/IWSLT06_JE_test_E.txt
echo " done."

wc -l * split/*
