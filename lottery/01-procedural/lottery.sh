#!/usr/bin/env bash
# Esimene etapp: järjestikune skript, ilma funktsioonideta.
echo "========== LOTO MÄNG =========="
: > player_numbers.txt || exit 1
: > lottery_numbers.txt || exit 1
read -r -p "Mängija nimi: " player || exit 1
player=${player:-Unknown}
count=0
while (( count < 5 )); do
    read -r -p "Vali number $((count + 1))/5 (1–50): " input || {
        echo "Sisend lõppes enne viie numbri sisestamist." >&2
        exit 1
    }
    if [[ -z "$input" ]]; then echo "Viga: sisesta number."; continue; fi
    if [[ ! "$input" =~ ^[0-9]+$ ]]; then echo "Viga: sisesta täisarv."; continue; fi
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
    echo "$number" >> player_numbers.txt || exit 1
    ((count += 1))
done
echo "Mängija valitud numbrid:"
cat player_numbers.txt
count=0
while (( count < 5 )); do
    number=$((RANDOM % 50 + 1))
    if grep -qxF -- "$number" lottery_numbers.txt; then continue; fi
    echo "$number" >> lottery_numbers.txt || exit 1
    ((count += 1))
done
echo "Loositud võidunumbrid:"
cat lottery_numbers.txt
matches=0
while IFS= read -r number; do
    echo "Kontrollin numbrit $number..."
    if grep -qxF -- "$number" lottery_numbers.txt; then
        echo "TABAMUS!"
        ((matches += 1))
    else
        echo "Ei tabanud."
    fi
done < player_numbers.txt
case "$matches" in
    5) result="JACKPOT!" ;;
    4) result="Väga hea tulemus!" ;;
    3) result="Hea tulemus." ;;
    2) result="Kaks tabamust." ;;
    1) result="Üks tabamus." ;;
    0) result="Seekord tabamusi ei olnud." ;;
esac
echo "Mängija: $player"
echo "Tabamusi: $matches / 5"
echo "$result"
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
} >> results.txt || exit 1
