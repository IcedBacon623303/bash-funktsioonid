#!/usr/bin/env bash
# Henri Haug · ITS24 · juhendi näide 16
fail_olemas() { [ -f "$1" ]; }
if fail_olemas "/etc/passwd"; then
    echo "Fail on olemas."
else
    echo "Faili ei leitud."
fi
for fail in "${BASH_SOURCE[0]}" "${BASH_SOURCE[0]}/puuduv.txt"; do
    if fail_olemas "$fail"; then echo "Kontroll: olemas"; else echo "Kontroll: puudub"; fi
done
