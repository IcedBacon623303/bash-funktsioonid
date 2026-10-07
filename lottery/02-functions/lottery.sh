#!/usr/bin/env bash
# Loto funktsioonidega ühes failis.

clear_files() {
    : > player_numbers.txt || return 1
    : > lottery_numbers.txt || return 1
}
save_result() {
    local player="$1" matches="$2" result="$3"
    {
        echo "========================================"
        echo "Date: $(date)"
        echo "Player: $player"
        echo "Player numbers:"
        cat player_numbers.txt
        echo "Lottery numbers:"
        cat lottery_numbers.txt
        echo "Matches: $matches"
        echo "Result: $result"
    } >> results.txt
}


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


generate_lottery_numbers() {
    local number count=0
    while (( count < 5 )); do
        number=$((RANDOM % 50 + 1))
        if grep -qxF -- "$number" lottery_numbers.txt; then continue; fi
        echo "$number" >> lottery_numbers.txt || return 1
        ((count += 1))
    done
}
show_lottery_numbers() {
    echo "Loositud võidunumbrid:"
    cat lottery_numbers.txt
}
check_matches() {
    local number matches=0
    while IFS= read -r number; do
        echo "Kontrollin numbrit $number..." >&2
        if grep -qxF -- "$number" lottery_numbers.txt; then
            echo "TABAMUS!" >&2
            ((matches += 1))
        else
            echo "Ei tabanud." >&2
        fi
    done < player_numbers.txt
    # Ainult arv läheb väljundisse; mänguteated lähevad stderr-i.
    echo "$matches"
}


show_header() { echo "========== LOTO MÄNG =========="; }
result_text() {
    case "$1" in
        5) echo "JACKPOT!" ;;
        4) echo "Väga hea tulemus!" ;;
        3) echo "Hea tulemus." ;;
        2) echo "Kaks tabamust." ;;
        1) echo "Üks tabamus." ;;
        0) echo "Seekord tabamusi ei olnud." ;;
        *) echo "Viga: vigane tabamuste arv." >&2; return 1 ;;
    esac
}
show_result() {
    local player="$1" matches="$2" result="$3"
    echo "Mängija: $player"
    echo "Tabamusi: $matches / 5"
    echo "$result"
}

show_header
clear_files || { echo "Failide loomine ebaõnnestus." >&2; exit 1; }
player=$(read_player) || { echo "Nime sisestamine jäi pooleli." >&2; exit 1; }
read_player_numbers || exit 1
show_player_numbers
generate_lottery_numbers || exit 1
show_lottery_numbers
matches=$(check_matches) || exit 1
result=$(result_text "$matches") || exit 1
show_result "$player" "$matches" "$result"
save_result "$player" "$matches" "$result" || exit 1
