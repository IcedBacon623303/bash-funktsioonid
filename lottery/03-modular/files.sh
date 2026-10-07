#!/usr/bin/env bash
# Omavahel seotud funktsioonid.
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
