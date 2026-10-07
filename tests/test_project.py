#!/usr/bin/env python3
"""Päris Bashiga käivitatavad kontrollid. Mänguandmed jäävad ajutisse kausta."""
import datetime
import json
import os
from pathlib import Path
import re
import shlex
import shutil
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[1]
BASH = os.environ.get('BASH_BINARY') or shutil.which('bash')
if not BASH:
    raise SystemExit('Bashi ei leitud. Paigalda Bash või määra BASH_BINARY.')
ENV = os.environ.copy()
ENV['LC_ALL'] = 'C.UTF-8'
results = []


def run(script, *, cwd=None, input='', args=(), command=False):
    argv = [BASH, '-c', script] if command else [BASH, str(script), *args]
    proc = subprocess.run(argv, cwd=cwd or ROOT, input=input.encode('utf-8'),
                          capture_output=True, timeout=20, env=ENV)
    proc.stdout = proc.stdout.decode('utf-8', errors='replace')
    proc.stderr = proc.stderr.decode('utf-8', errors='replace')
    return proc


def check(name, action):
    try:
        action()
        results.append({'test': name, 'status': 'PASS'})
        print('PASS', name)
    except Exception as exc:
        results.append({'test': name, 'status': 'FAIL', 'error': str(exc)})
        print('FAIL', name, str(exc))


def expect(ok, message):
    if not ok:
        raise AssertionError(message)


def syntax():
    files = sorted(ROOT.rglob('*.sh'))
    expect(len(files) == 27, f'Oodati 27 .sh faili, leiti {len(files)}')
    for path in files:
        raw = path.read_bytes()
        expect(b'\r' not in raw, f'{path.name}: CRLF reavahetused')
        proc = subprocess.run([BASH, '-n', str(path)], capture_output=True, text=True,
                              timeout=10, env=ENV)
        expect(proc.returncode == 0, f'{path.name}: {proc.stderr}')


checks = {
    1: lambda s, e: 'Tere!\nTänane kuupäev on:\n' in s,
    2: lambda s, e: s.count('SÜSTEEMI INFO') == 4,
    3: lambda s, e: s.splitlines() == ['Hello!', 'Hello!'],
    4: lambda s, e: 'olekukood: 127' in s and 'command not found' in e,
    5: lambda s, e: s.count('Tere tulemast!') == 3 and s.count('Tere!') == 5,
    6: lambda s, e: 'Kasutaja:\n' in s and 'Arvuti:\n' in s,
    7: lambda s, e: s.splitlines() == ['Tere, Mari!', 'Tere, Jüri!', 'Tere, Anna!',
                                     'Skripti esimene argument: Testargument'],
    8: lambda s, e: s.splitlines() == ['Nimi: Mari', 'Vanus: 18', '15'],
    9: lambda s, e: s.splitlines() == ['Argumentide arv: 3', '30',
                                     'Viga: sisesta kaks arvu!', 'Vigase kutse olekukood: 1'],
    10: lambda s, e: s.splitlines() == ['Funktsioonile anti:', 'üks', 'kaks', 'kolm',
                                      'Funktsioonile anti:', 'kaks sõna', ''],
    11: lambda s, e: s.splitlines() == ['Tere, Mari!', 'Mari'],
    12: lambda s, e: s.splitlines() == ['Mari', 'Väljaspool funktsiooni: Henri',
                                      'Tere, Mari!', 'Nimi: Mari', 'Vanus: 18'],
    13: lambda s, e: s.strip() == 'Tulemus: 30',
    14: lambda s, e: 'Fail on olemas.' in s and 'Faili ei leitud!' in s and 'olekukood: 1' in s,
    15: lambda s, e: 'Olemasolev fail: 0' in s and 'Puuduv fail: 1' in s,
    16: lambda s, e: 'Kontroll: olemas' in s and 'Kontroll: puudub' in s,
    17: lambda s, e: 'Skript jätkab tööd.' in s and 'exit-katse olekukood: 7' in s
                     and 'Seda ei kuvata.' not in s,
    18: lambda s, e: all(part in s for part in ['SYSTEM INFO', 'Kasutaja:', 'Arvuti:',
                                               'Kernel:', 'Kettakasutus:']),
    19: lambda s, e: len(s.splitlines()) == 4 and s.splitlines()[:2] == s.splitlines()[2:],
}


def example(number):
    paths = sorted(ROOT.glob(f'examples/{number:02d}-*.sh'))
    # Teema 19 abifaili ei käivitata eraldi.
    path = next(p for p in paths if p.name != '19-functions.sh')
    with tempfile.TemporaryDirectory(prefix='bash-example-') as folder:
        proc = run(path, cwd=folder, args=('Testargument',))
    expect(proc.returncode == 0, f'{path.name}: olekukood {proc.returncode}; {proc.stderr}')
    expect(checks[number](proc.stdout, proc.stderr), f'{path.name}: vale väljund {proc.stdout!r}')


MESSAGES = ['Seekord tabamusi ei olnud.', 'Üks tabamus.', 'Kaks tabamust.',
            'Hea tulemus.', 'Väga hea tulemus!', 'JACKPOT!']


def verify_game(folder, proc, expected_player, expected_numbers):
    expect(proc.returncode == 0, f'Loto ei lõppenud edukalt: {proc.stderr}')
    player = (Path(folder) / 'player_numbers.txt').read_text(encoding='utf-8').splitlines()
    drawn = (Path(folder) / 'lottery_numbers.txt').read_text(encoding='utf-8').splitlines()
    expect(player == expected_numbers, f'Vale mängija numbrite loend: {player}')
    expect(len(drawn) == 5 and len(set(drawn)) == 5, f'Loosimisel kordus: {drawn}')
    expect(all(1 <= int(n) <= 50 for n in drawn), f'Loosimise vahemik: {drawn}')
    matches = len(set(player) & set(drawn))
    expect(f'Mängija: {expected_player}' in proc.stdout, 'Mängija nimi ei sobi')
    expect(f'Tabamusi: {matches} / 5' in proc.stdout, 'Tabamused ei vasta failide sisule')
    expect(MESSAGES[matches] in proc.stdout, 'Tulemuse hinnang ei sobi')
    log = (Path(folder) / 'results.txt').read_text(encoding='utf-8')
    expect(f'Player: {expected_player}\n' in log, 'Nimi ei salvestunud')
    expect(f'Matches: {matches}\nResult: {MESSAGES[matches]}' in log, 'Tulemus ei salvestunud')
    expect('Date: ' in log and 'Player numbers:\n' in log and 'Lottery numbers:\n' in log,
           'Ajalookirje vajalikud väljad puuduvad')
    expect(proc.stdout.count('Kontrollin numbrit') + proc.stderr.count('Kontrollin numbrit') == 5,
           'Kõiki viit numbrit ei võrreldud')
    return log


def game(stage, case):
    script = ROOT / 'lottery' / stage / 'lottery.sh'
    with tempfile.TemporaryDirectory(prefix='bash-lottery-') as folder:
        if case == 'valid':
            proc = run(script, cwd=folder, input='Henri\n1\n2\n3\n4\n50\n')
            verify_game(folder, proc, 'Henri', ['1', '2', '3', '4', '50'])
        elif case == 'invalid':
            text = '\n\nabc\n1.5\n-1\n0\n51\n999999999999999999999999999\n08\n8\n09\n10\n11\n50\n'
            proc = run(script, cwd=folder, input=text)
            verify_game(folder, proc, 'Unknown', ['8', '9', '10', '11', '50'])
            for message in ['sisesta number', 'sisesta täisarv', 'vahemikus 1–50', 'juba valitud']:
                expect(message in proc.stdout, f'Veateade puudub: {message}')
        elif case == 'history':
            proc = run(script, cwd=folder, input='Esimene\n1\n2\n3\n4\n5\n')
            first = verify_game(folder, proc, 'Esimene', ['1', '2', '3', '4', '5'])
            proc = run(script, cwd=folder, input='Teine\n6\n7\n8\n9\n10\n')
            second = verify_game(folder, proc, 'Teine', ['6', '7', '8', '9', '10'])
            expect(second.startswith(first), 'Eelmine mäng kirjutati üle')
            expect(second.count('Date: ') == 2, 'Ajalugu ei sisalda kahte mängu')
        elif case == 'eof':
            proc = run(script, cwd=folder, input='Henri\n1\n')
            expect(proc.returncode != 0, 'Pooleli sisend loeti edukaks mänguks')
            log = Path(folder) / 'results.txt'
            expect(not log.exists(), 'Pooleli mäng lisati ajalukku')
        elif case == 'random':
            for _ in range(10):
                proc = run(script, cwd=folder, input='Katse\n1\n2\n3\n4\n5\n')
                verify_game(folder, proc, 'Katse', ['1', '2', '3', '4', '5'])


def source(path):
    return 'source ' + shlex.quote(path.as_posix()) + '; '


def result_cases():
    prefix = source(ROOT / 'lottery/03-modular/result.sh')
    proc = run(prefix + 'for n in {0..5}; do result_text "$n"; done; '
               'result_text 6; status=$?; echo "invalid=$status"', command=True)
    expect(proc.stdout.splitlines() == MESSAGES + ['invalid=1'], 'Vale tulemusvariandi tekst')


def matches_cases():
    prefix = source(ROOT / 'lottery/03-modular/lottery_functions.sh')
    with tempfile.TemporaryDirectory(prefix='bash-matches-') as folder:
        (Path(folder) / 'player_numbers.txt').write_text('1\n2\n3\n4\n5\n', newline='')
        for count in range(6):
            values = list(range(1, count + 1)) + list(range(40, 45 - count))
            (Path(folder) / 'lottery_numbers.txt').write_text(''.join(f'{v}\n' for v in values), newline='')
            proc = run(prefix + 'check_matches', cwd=folder, command=True)
            expect(proc.returncode == 0 and proc.stdout.strip() == str(count),
                   f'{count} tabamuse arvutus ebaõnnestus')
            expect(proc.stderr.count('TABAMUS!') == count, 'Tabamuste teated ei vasta tulemusele')


def duplicate_draw():
    prefix = source(ROOT / 'lottery/03-modular/lottery_functions.sh')
    with tempfile.TemporaryDirectory(prefix='bash-draw-') as folder:
        (Path(folder) / 'lottery_numbers.txt').write_text('')
        # Järjestatud RANDOM-jada algab kordusega; päris funktsioon peab selle vahele jätma.
        # Bashi RANDOM on eritähendusega; unset võimaldab kontrollitud sama nimega sisendit.
        command = prefix + '''
unset RANDOM
values=(0 0 1 2 3 4)
index=0
grep() {
    command grep "$@"
    status=$?
    ((index += 1))
    RANDOM=${values[index]:-5}
    return "$status"
}
RANDOM=${values[0]}
generate_lottery_numbers
'''
        proc = run(command, cwd=folder, command=True)
        drawn = (Path(folder) / 'lottery_numbers.txt').read_text().splitlines()
        expect(proc.returncode == 0 and drawn == ['1', '2', '3', '4', '5'],
               f'Duplikaadi uuesti loosimine ei töötanud: {drawn}')


check('27 Bash-faili süntaks ja LF reavahetused', syntax)
for number in range(1, 20):
    check(f'Näidisteema {number:02d}', lambda n=number: example(n))
for stage in ['01-procedural', '02-functions', '03-modular']:
    for case in ['valid', 'invalid', 'history', 'eof', 'random']:
        check(f'Loto {stage}: {case}', lambda s=stage, c=case: game(s, c))
check('Kõik kuus tulemuse hinnangut ja vigane tabamuste arv', result_cases)
check('Kõik kuus tabamuste arvu päris failidega', matches_cases)
check('Loositud duplikaat jäetakse vahele', duplicate_draw)
report = {
    'checked_at_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
    'bash': subprocess.run([BASH, '--version'], capture_output=True, text=True).stdout.splitlines()[0],
    'total': len(results),
    'passed': sum(r['status'] == 'PASS' for r in results),
    'failed': sum(r['status'] == 'FAIL' for r in results),
    'tests': results,
}
(ROOT / 'evidence').mkdir(exist_ok=True)
(ROOT / 'evidence/test-results.json').write_text(json.dumps(report, ensure_ascii=False, indent=2) + '\n',
                                              encoding='utf-8')
print(f"{report['passed']}/{report['total']} kontrolli läbitud")
raise SystemExit(bool(report['failed']))
