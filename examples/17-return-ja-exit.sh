#!/usr/bin/env bash
# Henri Haug · ITS24 · juhendi näide 17
kontroll() {
    if [ ! -f "$1" ]; then echo "Faili pole."; return 1; fi
    echo "Fail leitud."
}
kontroll "/tmp/test.txt"
echo "Skript jätkab tööd."
# exit-katse on alamkestas, et näiteskript ise saaks jätkata.
"$BASH" -c 'kontroll() { echo "exit lõpetab skripti."; exit 7; }; kontroll; echo "Seda ei kuvata."'
kood=$?
echo "exit-katse olekukood: $kood"
[[ "$kood" -eq 7 ]]
