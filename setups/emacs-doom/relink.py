#!/usr/bin/env python3

# flake8: noqa: E500
# ruff: noqa: E500

import collections
import re
import sys

REPLACE = {
    '[[GS/EMS/Power Loss Monitor]]': '[[id:3ab4830c-c767-4be6-a28e-4210792cefc5][Power Loss Monitor]]',
    '[[GS/EXH]]': '[[id:54be766c-b389-4c6b-9b19-31ebb52a47b0][EXH]]',
    '[[GS/GOT]]': '[[id:d89830fa-91d4-4d77-a0f1-2f200437fac1][GOT]]',
    '[[GS/Infra/EXH-prod]]': '[[id:6dff142e-24f0-491b-b88c-e888e08c802b][EXH-prod]]',
    '[[GS/Infra/GOT-test]]': '[[id:cdc037aa-121f-429f-8e09-0812a88787a0][GOT-test]]',
    '[[Pe/Diogo Henriques]]': '[[id:dcf495cc-82c8-4517-9e84-55ba278dfe8d][Diogo Henriques]]',
    '[[Pe/Nuno Ferreira]]': '[[id:4a7c3298-c2b6-4083-9c4c-1b79a8b22d71][Nuno Ferreira]]',
    '[[Pe/Raquel Santos]]': '[[id:4b023b9c-87be-45f5-81e5-6ee76f6be770][Raquel Santos]]',
    '[[Ref/WhatsApp]]': '[[id:1ce69ce3-a4dd-4c42-9e0d-26917f183869][WhatsApp]]',
    '[[logging]]': '[[id:f053d058-f7cf-4b4b-a9c2-f5301462b376][logging]]',
    '[[t/log]]': '[[id:3ca16330-e3dc-43e7-ba59-ea94943f9fc8][t.log]]',
    '[[to/consider]]': '[[id:201a6008-ffba-49ee-a27e-c25dfb331497][to.consider]]',
}


def main():
    cmd = sys.argv[1]
    target = sys.argv[2]

    if cmd == 'search':
        link = '[[Ref/WhatsApp]]'
        p = re.escape(link)
        p = r'\[\[[a-zA-Z0-9\s\/-]*\]\]'

        with open(target, 'r') as f:
            text = '\n'.join(f.readlines())

        matches = re.findall(p, text)
        counter = collections.Counter(matches)
        for k, v in counter.items():
            note = '' if k in REPLACE else '(no link)'
            print(f'{v:2d} {k} {note}')

    elif cmd == 'replace':
        with open(target, 'r+') as f:
            text = f.read()

            for k, v in REPLACE.items():
                text = re.sub(re.escape(k), v, text)

            # fp = Path(target)
            # fp = fp.with_stem(fp.stem + '.2')
            # print(fp)

            f.seek(0)
            f.write(text)
            f.truncate()

    else:
        assert False, f'invalid cmd {cmd}'


if __name__ == "__main__":
    main()
