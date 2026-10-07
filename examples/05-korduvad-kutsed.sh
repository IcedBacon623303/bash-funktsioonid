#!/usr/bin/env bash
# Henri Haug · ITS24 · juhendi näide 05
hello() { echo "Tere tulemast!"; }
hello
hello
hello
hello() { echo "Tere!"; }
for i in {1..5}; do
    hello
done
