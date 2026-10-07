#!/usr/bin/env bash
# Henri Haug · ITS24 · juhendi näide 06
show_user() { echo "Kasutaja:"; whoami; }
show_host() { echo "Arvuti:"; hostname; }
show_system() { show_user; show_host; }
show_system
