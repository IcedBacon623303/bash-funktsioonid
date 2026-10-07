#!/usr/bin/env bash
# Henri Haug · ITS24 · juhendi näide 09
kontrolli() { echo "Argumentide arv: $#"; }
kontrolli üks kaks kolm
liida() {
    if [ "$#" -ne 2 ]; then
        echo "Viga: sisesta kaks arvu!"
        return 1
    fi
    echo "$(($1 + $2))"
}
liida 10 20
liida 10
kood=$?
echo "Vigase kutse olekukood: $kood"
[[ "$kood" -eq 1 ]]
