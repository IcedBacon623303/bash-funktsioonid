#!/usr/bin/env bash
# Henri Haug · ITS24 · juhendi näide 04
hello() { echo "Hello!"; }
hello
# Vale järjekord on teadlik katse eraldi alamkestas.
# Alamkestas pole hello veel defineeritud: esimene käsk annab 127.
"$BASH" -c 'hello; kood=$?; hello() { echo "Hello!"; }; exit "$kood"'
kood=$?
echo "Enne defineerimist kutsumise olekukood: $kood"
[[ "$kood" -eq 127 ]]
