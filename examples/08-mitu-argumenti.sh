#!/usr/bin/env bash
# Henri Haug · ITS24 · juhendi näide 08
kasutaja_info() { echo "Nimi: $1"; echo "Vanus: $2"; }
kasutaja_info "Mari" 18
liida() { echo "$(($1 + $2))"; }
liida 10 5
