#!/usr/bin/env bash
# Henri Haug · ITS24 · juhendi näide 12
nimi="Henri"
test() { local nimi="Mari"; echo "$nimi"; }
test
echo "Väljaspool funktsiooni: $nimi"
tervita() { local nimi="$1"; echo "Tere, $nimi!"; }
tervita "Mari"
kasutaja_info() {
    local nimi="$1"
    local vanus="$2"
    echo "Nimi: $nimi"
    echo "Vanus: $vanus"
}
kasutaja_info "Mari" 18
