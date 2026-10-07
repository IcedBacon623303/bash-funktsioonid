#!/usr/bin/env bash
# Henri Haug · ITS24 · juhendi näide 10
naita() {
    echo "Funktsioonile anti:"
    for argument in "$@"; do echo "$argument"; done
}
naita "üks" "kaks" "kolm"
# Jutumärgid säilitavad ka tühikutega argumendi ühe väärtusena.
naita "kaks sõna" ""
