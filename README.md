# Bashi funktsioonid ja Loto mäng

Henri Haug · ITS24 · VOCO

Siin on **19 eraldi käivitatavat Bashi näidet** ja Loto mängu kolm versiooni. Funktsioon on nimetatud käsuplokk, mida saab uuesti kasutada. Iga näide on salvestatud GitHubi eraldi muudatusena. Näide 19 kasutab ka abifaili.

## Käivitamine

Vaja on Bashi ja tavapäraseid käske `grep`, `cat`, `date`, `dirname`, `hostname`, `uname`, `whoami`, `df`. Sobib Linux või Git Bashi keskkond. Skripte käivita Bashiga, mitte `dash`-iga.

```bash
bash examples/01-funktsioon.sh
bash -x examples/12-lokaalne-muutuja.sh
bash lottery/03-modular/lottery.sh
```

Linuxis saab käivitusfaili käivitada ka otse:

```bash
cd lottery/03-modular
chmod +x lottery.sh
./lottery.sh
```

Mäng küsib nime ja viis erinevat täisarvu vahemikus 1–50. Tühi nimi muutub nimeks Unknown. Vigast numbrit küsitakse uuesti. Võidunumbrid loositakse `$RANDOM` abil, duplikaate vältides. Mängu tulemus lisatakse `results.txt` lõppu. Mänguandmed tekivad **käivitamise töökataloogi**; uut mängu alustades tühjendatakse ainult numbrite failid. Proovimiseks kasuta eraldi tühja kataloogi.

## 19 näidisteemat

| Teema | Skript | Mida kontrollib |
|---|---|---|
| 1 | [01-funktsioon.sh](examples/01-funktsioon.sh) | funktsioon |
| 2 | [02-korduse-vahendamine.sh](examples/02-korduse-vahendamine.sh) | korduse vähendamine |
| 3 | [03-suntaks.sh](examples/03-suntaks.sh) | süntaks |
| 4 | [04-defineerimise-jarjekord.sh](examples/04-defineerimise-jarjekord.sh) | defineerimise järjekord |
| 5 | [05-korduvad-kutsed.sh](examples/05-korduvad-kutsed.sh) | korduvad kutsed |
| 6 | [06-funktsioon-kutsub-funktsiooni.sh](examples/06-funktsioon-kutsub-funktsiooni.sh) | funktsioon kutsub funktsiooni |
| 7 | [07-argument.sh](examples/07-argument.sh) | argument |
| 8 | [08-mitu-argumenti.sh](examples/08-mitu-argumenti.sh) | mitu argumenti |
| 9 | [09-argumentide-arv.sh](examples/09-argumentide-arv.sh) | argumentide arv |
| 10 | [10-koik-argumendid.sh](examples/10-koik-argumendid.sh) | kõik argumendid |
| 11 | [11-globaalne-muutuja.sh](examples/11-globaalne-muutuja.sh) | kogu skriptis kasutatav muutuja |
| 12 | [12-lokaalne-muutuja.sh](examples/12-lokaalne-muutuja.sh) | ainult funktsioonis kasutatav muutuja |
| 13 | [13-tulemus-valjundist.sh](examples/13-tulemus-valjundist.sh) | tulemuse lugemine väljundist |
| 14 | [14-return.sh](examples/14-return.sh) | return |
| 15 | [15-olekukood.sh](examples/15-olekukood.sh) | olekukood |
| 16 | [16-funktsioon-tingimuses.sh](examples/16-funktsioon-tingimuses.sh) | funktsioon tingimuses |
| 17 | [17-return-ja-exit.sh](examples/17-return-ja-exit.sh) | return ja exit |
| 18 | [18-susteemi-info.sh](examples/18-susteemi-info.sh) | süsteemi info |
| 19 | [19-taaskasutamine.sh](examples/19-taaskasutamine.sh) | taaskasutamine |

Teemad 20–21 on juhendi mõistete kokkuvõte, mitte eraldi koodiharjutused. Näidistes on läbi tehtud ka alternatiivsed süntaksid ja lisavariandid. Teemas 4 on vale kutsumisjärjekorra viga teadlik katse: olekukood 127 on oodatud. Teemas 17 on `exit` eraldi alamkestas, et selle mõju oleks võrreldav `return`-iga. Failikontrollide näited kasutavad nii juhendi teid kui skripti enda faili ja kindlasti puuduvat alamteed.

## Loto kolm versiooni

- [01-procedural](lottery/01-procedural/lottery.sh): käsud käivitatakse järjest, funktsioone ei kasutata.
- [02-functions](lottery/02-functions/lottery.sh): sama mäng selgelt nimetatud funktsioonidega ühes failis.
- [03-modular](lottery/03-modular/lottery.sh): lühike käivitusfail, mis laadib sisendi, loosimise, tulemuste ja failide funktsioonid eraldi failidest. `local` hoiab abimuutujad funktsiooni sees; `return` annab teada veast. Argumentidega edastatakse mängija nimi, tabamused ja tulemuse tekst.

## Kontrollimine

```bash
python3 tests/test_project.py
```

Testid käivitavad päris Bashi, kontrollivad kõigi failide süntaksit, 19 näidise väljundit, Loto sisendivigu, loosimise vahemikku ja kordumatust, tabamuste tegelikku arvu, ajaloofaili säilimist ja kõiki kuut tulemusvarianti. Testid teevad oma failid ajutistesse kaustadesse. Kohaliku kontrolli kokkuvõte on [evidence/test-results.json](evidence/test-results.json).

## Õppematerjal ja töö koostamine

[Moodle: BASH skriptid – Funktsioonid](https://moodle.voco.ee/course/section.php?id=8765) · [Funktsioonide teooria](https://docs.google.com/document/d/1_IJMs30GgEbxvaxa1J7pi3c_-UMVGRCtsYmBUzz2LWs/edit)

Lahendused ja testid on koostatud Codexi abiga. Algmaterjal on õpetaja juhend; siin on selle põhjal käivitatavad lahendused ja kontrollid. Juhendi täisteksti ei ole siia kopeeritud.
