#!/usr/bin/env bash
# Henri Haug · ITS24 · juhendi näide 14
kontrolli_faili() {
    if [ ! -f "$1" ]; then
        echo "Faili ei leitud!"
        return 1
    fi
    echo "Fail on olemas."
}
# Skripti enda fail on olemas, puuduv alamtee pole olemas.
kontrolli_faili "${BASH_SOURCE[0]}"
kontrolli_faili "${BASH_SOURCE[0]}/puuduv.txt"
kood=$?
echo "Skript jätkab. Puuduva faili olekukood: $kood"
[[ "$kood" -eq 1 ]]
