#!/usr/bin/env bash
# Henri Haug · ITS24 · juhendi näide 19
# Lae abifail skripti asukoha järgi: töötab ka teisest kataloogist.
skripti_kaust=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$skripti_kaust/19-functions.sh"
show_user
show_host
# Juhendi teine laadimisviis.
. "$skripti_kaust/19-functions.sh"
show_user
show_host
