#!/usr/bin/env python3

# ignore: E500
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
    '[[Ref/Graylog]]': '[[id:fb6d1849-bca8-447b-81d3-405a6ca7f431][Graylog]]',
    '[[Ref/restic]]': '[[id:d00af650-6e7b-47e3-879d-5428ce34c24f][restic]]',
    '[[Ref/1NCE]]': '[[id:356671d4-b2fd-4d4f-8d3e-61ecfb955008][1NCE]]',
    '[[Ref/OpenVPN]]': '[[id:a8c5d939-9909-498c-8ea8-5abfdeee4735][OpenVPN]]',
    '[[Ref/ESP32S3]]': '[[id:8d420381-4153-4001-8d6e-21e0e4c0d5dd][ESP32S3]]',
    '[[Ref/ZeroMQ]]': '[[id:cec89197-8051-4de6-980e-0ecf6c9b42c6][ZeroMQ]]',
    '[[Ref/Bluetooth]]': '[[id:3a2be2c9-4daf-4795-b73e-a622deb65f01][Bluetooth]]',
    '[[GS/EOT]]': '[[id:9c5ee471-94bd-4826-a852-a76d5350ea5d][EOT]]',
    '[[GS]]': '[[id:fe350e80-670d-4ea0-939f-ae1798e25e41][GS]]',
    '[[GS/EMS]]': '[[id:6efa8442-0239-4df4-b326-1dc10a55c749][EMS]]',
    '[[GS/SAT1]]': '[[id:3aac5e64-fd67-488d-a82c-fe4d9dbbadaa][GS-SAT1]]',
    #
    '[[to/consider]]': '[[id:201a6008-ffba-49ee-a27e-c25dfb331497][to.consider]]',
    '[[to/discuss]]': '[[id:751798e1-1210-4828-964c-f536a4929c2b][to-discuss]]',
    '[[to/experiment': '[[id:70b3d438-99f9-4a61-8303-749d68e7d65c][to-experiment]]',

    #
    '[[t/log]]': '[[id:3ca16330-e3dc-43e7-ba59-ea94943f9fc8][t.log]]',
    '[[t/consider]]': '[[id:201a6008-ffba-49ee-a27e-c25dfb331497][to-consider]]',
    '[[t/notes]]': '[[id:ff9929c4-77af-40fe-b82b-a1d922658d77][t-notes]]',
    '[[t/meeting]]': '[[id:df8c2ab0-0229-433c-9e4e-0ae35a52df95][t-meeting]]',
    #
    '[[self-hosted]]': '[[id:0c94b234-b12e-40e9-9066-9a436ad4639d][self-hosted]]',
    '#self-hosted': '[[id:0c94b234-b12e-40e9-9066-9a436ad4639d][self-hosted]]',
    '[[sysadmin]]': '[[id:5721d54b-262a-44be-bf1a-bd8014a999db][sysadmin]]',
    '#sysadmin': '[[id:5721d54b-262a-44be-bf1a-bd8014a999db][sysadmin]]',
    '[[backups]]': '[[id:ef4a7d2a-60f1-43ae-a904-d491073f344c][backups]]',
    '#backups': '[[id:ef4a7d2a-60f1-43ae-a904-d491073f344c][backups]]',
    '[[network-overlay]]': '[[id:7681ce76-423f-4694-8881-9bfd65d482db][network-overlay]]',
    '#network-overlay': '[[id:7681ce76-423f-4694-8881-9bfd65d482db][network-overlay]]',
    '#logging': '[[id:f053d058-f7cf-4b4b-a9c2-f5301462b376][logging]]',
    '[[logging]]': '[[id:f053d058-f7cf-4b4b-a9c2-f5301462b376][logging]]',
    '[[dev-tools]]': '[[id:4ee253b3-2611-4898-812b-1927fad2e1fa][dev_tools]]',
    '#dev-tools': '[[id:4ee253b3-2611-4898-812b-1927fad2e1fa][dev_tools]]',
    '[[product]]': '[[id:4aca2a21-db29-4c64-95b8-0c80eb9f5397][product]]',
    '#product': '[[id:4aca2a21-db29-4c64-95b8-0c80eb9f5397][product]]',
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
                text = re.sub(r'#?' + re.escape(k), v, text)

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
