#!/bin/bash

profile2deltas `for n in 000 001 002 $(seq -w 006 100); do echo ~/tbs/ja2en/tanaka-$n.jaen; done` | tee sd.txt
sd2deltas.py < sd.txt | tee tc-deltas.txt
sort -k3n -k2n tc-deltas.txt | sed 's/ /\t/g' > tc-deltas.sorted.txt
grep -Ei -e '-O?MTR' tc-deltas.sorted.txt > $HOME/www/data/tc-deltas.sorted.txt
