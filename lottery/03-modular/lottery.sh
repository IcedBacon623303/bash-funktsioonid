#!/usr/bin/env bash
# Henri Haug · ITS24. Käivitusfail; mänguandmed tekivad töökataloogi.
skripti_kaust=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd) || exit 1
source "$skripti_kaust/files.sh" || exit 1
source "$skripti_kaust/input.sh" || exit 1
source "$skripti_kaust/lottery_functions.sh" || exit 1
source "$skripti_kaust/result.sh" || exit 1

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
