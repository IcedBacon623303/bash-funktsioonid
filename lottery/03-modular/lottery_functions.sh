#!/usr/bin/env bash
# Omavahel seotud funktsioonid.
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
