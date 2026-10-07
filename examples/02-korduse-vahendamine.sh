#!/usr/bin/env bash
# Henri Haug · ITS24 · juhendi näide 02
# Kõigepealt sama tegevus ilma funktsioonita, nagu juhendis.
echo "===================="
echo "SÜSTEEMI INFO"
echo "===================="
hostname
uname -r
whoami
echo "===================="
echo "SÜSTEEMI INFO"
echo "===================="
hostname
uname -r
whoami
# Sama tulemus funktsiooni taaskasutades.
system_info() {
    echo "===================="
    echo "SÜSTEEMI INFO"
    echo "===================="
    hostname
    uname -r
    whoami
}
system_info
system_info
