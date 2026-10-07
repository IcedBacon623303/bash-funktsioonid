#!/usr/bin/env bash
# Henri Haug · ITS24 · juhendi näide 13
liida() { local a="$1"; local b="$2"; echo "$((a + b))"; }
tulemus=$(liida 10 20)
echo "Tulemus: $tulemus"
