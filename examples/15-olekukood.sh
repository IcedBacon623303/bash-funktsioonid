#!/usr/bin/env bash
# Henri Haug · ITS24 · juhendi näide 15
kontrolli_faili() {
    if [ -f "$1" ]; then return 0; else return 1; fi
}
kontrolli_faili "/etc/passwd"
echo "Juhendi /etc/passwd katse: $?"
kontrolli_faili "${BASH_SOURCE[0]}"
echo "Olemasolev fail: $?"
kontrolli_faili "${BASH_SOURCE[0]}/puuduv.txt"
echo "Puuduv fail: $?"
