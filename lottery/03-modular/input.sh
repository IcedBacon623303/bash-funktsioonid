#!/usr/bin/env bash
# Omavahel seotud funktsioonid.
read_player() {
    local player
    read -r -p "Mängija nimi: " player || return 1
    printf '%s\n' "${player:-Unknown}"
}
read_player_numbers() {
    local input number count=0
    while (( count < 5 )); do
        read -r -p "Vali number $((count + 1))/5 (1–50): " input || {
            echo "Sisend lõppes enne viie numbri sisestamist." >&2
            return 1
        }
        if [[ -z "$input" ]]; then
            echo "Viga: sisesta number."
            continue
        fi
        if [[ ! "$input" =~ ^[0-9]+$ ]]; then
            echo "Viga: sisesta täisarv."
            continue
        fi
        # Lubame algusnulli (nt 08). Eemaldame need enne arvutamist,
        # et vältida kaheksandsüsteemi ja väga pika arvu ületäitumist.
        number="$input"
        while [[ "$number" == 0* && ${#number} -gt 1 ]]; do number="${number#0}"; done
        if [[ ${#number} -gt 2 ]] || (( number < 1 || number > 50 )); then
            echo "Viga: number peab olema vahemikus 1–50."
            continue
        fi
        if grep -qxF -- "$number" player_numbers.txt; then
            echo "Viga: see number on juba valitud."
            continue
        fi
        echo "$number" >> player_numbers.txt || return 1
        ((count += 1))
    done
}
show_player_numbers() {
    echo "Mängija valitud numbrid:"
    cat player_numbers.txt
}
