#!/usr/bin/env bash
# Omavahel seotud funktsioonid.
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
