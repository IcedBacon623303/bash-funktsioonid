#!/usr/bin/env bash
# Henri Haug · ITS24 · juhendi näide 07
tervita() { echo "Tere, $1!"; }
tervita "Mari"
tervita "Jüri"
tervita "Anna"
# Funktsiooni argumendid ei asenda skripti argumente jäädavalt.
echo "Skripti esimene argument: ${1-argument puudub}"
