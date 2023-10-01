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
    '[[Guide/Hand exercices]]': '[[id:69e549e8-a850-4e5b-867f-3889649c4c50][Hand Exercices]]',
    '[[Ref/Groxy]]': '[[id:f1cea066-b020-4c62-9a85-57deefb1b438][Grocy]]',
    '[[Someday]]': '[[id:0652a5ff-d044-4167-b217-8fd6ffa85af4][Someday]]',
    '[[Ref/Django]]': '[[id:6301ec94-924a-4735-9c0c-b7c7f89891be][Django]]',
    '[[Ref/Redis]]': '[[id:1c83765a-56d9-4df3-a65a-c3c3ecd2f66b][Redis]]',
    '[[Ref/LogSeq]]': '[[id:3d589131-5adf-4d74-bee3-2451a3388d62][LogSeq]]',
    '[[Ref/PARA Method]]': '[[id:83f73ad3-19b2-41a4-9a53-ede094f0721d][PARA Method]]',
    '[[Refile]]': '[[id:f178f064-779f-4bab-8e96-3fa3dc49cb08][Inbox]]',
    '[[gtd]]': '[[id:63cfc687-d36d-4670-b181-664c388a663a][GTD]]',
    '[[Index]]': '[[id:59ec4c6a-a891-45c3-b3d3-8a2be43216bd][Index]]',
    '[[GS/Automotive]]': '[[id:ecd46ebe-7177-49a1-9f5c-6c33ef6c44ee][GSAutomotive]]',
    '[[M/Programa Cujo Nome Estamos Legalmente Impedidos de Dizer]]':
    '[[id:acd6178f-1853-4a41-a7f6-e34af44dd651][Programa Cujo Nome Estamos Legalmente Impedidos de Dizer]]',
    '[[M/Starfield]]': '[[bec5f688-4b3a-4f6d-ae36-c609dc5ea54c][Starfield]]',
    '[[M/The WAN Show]]': '[[id:4b4776d5-eeb2-4800-9a44-d61d287198d0][WAN Show]]',
    '[[Pe/Linux Sebastion]]': '[[id:4b4776d5-eeb2-4800-9a44-d61d287198d0][Linux Sebastion (LTT)]]',
    '[[Social]]': '[[id:93dd483f-54a3-4e0c-a929-f9374d032d2d][Social]]',
    '[[emeter]]': '[[id:51346329-9b77-4a3c-8d1a-e6d04065f2a2][emeter]]',
    '[[enshitification]]': '[[id:9eaa1cf8-fb36-490d-b95a-83326df555c8][enshitification]]',
    '[[fw]]': '[[id:e8dc19f3-08ed-41cb-b0f7-b0186ae87320][fw]]',
    '[[gaming]]': '[[id:ff9a5497-1a70-4821-9710-01d675341f86][gaming]]',
    '[[privacy]]': '[[id:6d3dadc1-7fa9-4506-8224-efa38cd6534f][privacy]]',
    '[[Ref/Obsidian]]': '[[id:df5d4e28-2810-400c-ba1f-fb4fcde104dc][Obsidian]]',
    '[[Ref/PPV]]': '[[id:f6ab982c-8338-4bf2-95a6-1af3bf56cf20][Ref/PPV]]',
    '[[Ref/Quinta Curvilho]]': '[[id:f4973861-bc19-4ec9-9d2d-7470ed91ded2][Quinta Curvilho]]',
    '[[Ref/Rockstar]]': '[[id:801f16b0-8141-45df-80eb-5de884fce3d7][Rockstar]]',
    '[[Ref/SOAP]]': '[[id:32e2b558-1d52-4b0f-801b-eff82e467489][SOAP]]',
    '[[Ref/Steam]]': '[[id:93f9c7dd-5304-4053-bee4-5b8fd8acb2e7][Steam]]',
    '[[Ref/Syncthing]]': '[[id:cff923ca-a189-4368-936b-adf535fb59ca][Syncthing]]',
    '[[Ref/Tesla]]': '[[id:62bce4a4-80e9-4231-9ecd-0907c30621b7][Tesla]]',
    '[[Ref/Unity]]': '[[id:0bbefaa6-8ff6-4625-83d3-917d6c01c957][Unity]]',
    '[[Ref/XeSS]]': '[[id:da44a95f-97a1-462a-8047-d51afe4861c5][XeSS]]',
    '[[Ref/alex-server]]': '[[id:3bd0e0f4-c221-451c-a087-6bf05b6c0df7][alex-server]]',
    '[[Ref/resticprofile]]': '[[id:5135e3c8-b3d2-4897-9c36-84cba8ae7b8e][resticprofile]]',

    '[[Pe/Pedro Gameiro]]': '[[id:a3b4e7fe-e748-4ac4-8f8b-31edef1f9312][edro Gameiro]]',
    '[[Ref/Ansible]]': '[[id:c621a020-dd62-4ee4-9748-ec124e5fe3c6][Ansible]]',
    '[[Ref/DLSS]]': '[[id:8df53f2d-b566-47a2-b4fe-25db5b2518c0][DLSS]]',
    '[[Ref/EU]]': '[[id:1d5f297b-3668-490f-948a-d0605ee4ea56][EU]]',
    '[[Ref/FSR2]]': '[[id:228ff40b-3269-4428-910f-afcb3d934045][FSR2]]',
    '[[Ref/GTD]]': '[[id:63cfc687-d36d-4670-b181-664c388a663a][GTD]]',
    '[[Ref/Mozilla]]': '[[id:aba7175e-1e62-42c0-a767-9aa1357db435][Mozilla]]',
    '[[Ref/My Moonlander layout]]': '[[id:4772424f-8fc9-4aa4-ba2d-88009da72362][My Moonlander layout]]',
    '[[Ref/NextBITT]]': '[[id:a4c0bfcf-f34a-4c32-a36a-630efdab2abd][NextBITT]]',
    '[[Ref/Notion]]': '[[id:dbc2f2fe-366b-4253-b72f-d049e6ff509c][Notion]]',


    #
    '[[to/consider]]': '[[id:201a6008-ffba-49ee-a27e-c25dfb331497][to.consider]]',
    '[[to/discuss]]': '[[id:751798e1-1210-4828-964c-f536a4929c2b][to-discuss]]',
    '[[to/experiment]]': '[[id:70b3d438-99f9-4a61-8303-749d68e7d65c][to-experiment]]',
    '[[to/refile]]': '[[id:2094d6a7-82d3-4baa-a9a1-91def8426031][to-refile]]',

    #
    '[[t/log]]': '[[id:3ca16330-e3dc-43e7-ba59-ea94943f9fc8][t.log]]',
    '[[t/consider]]': '[[id:201a6008-ffba-49ee-a27e-c25dfb331497][to-consider]]',
    '[[t/notes]]': '[[id:ff9929c4-77af-40fe-b82b-a1d922658d77][t-notes]]',
    '[[t/meeting]]': '[[id:df8c2ab0-0229-433c-9e4e-0ae35a52df95][t-meeting]]',
    '[[t/media/video]]': 'media-video',
    '[[t/sw]]': 'sw-other',

    #
    '[[s/unconsumed]]': '[[id:d82c7546-6897-41c8-8318-7fe12eecbca5][s-unconsumed]]',
    '[[s/consumed]]': '[[id:e7db87f9-7aec-43a4-adae-51d786c4568a][s/consumed]]',

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

    #
    '[[2023-08-27 Sunday]]': '[[id:f73c7ef0-9a22-4c30-8c4c-595e463b24c1][2023-08-27]]',
    '[[2023-09-04 Monday]]': '[[id:9f76d6d9-326f-4d2e-a763-2f463e352ede][2023-09-04]]',
    '[[2023-09-08 Friday]]': '[[id:3127d1dd-8150-4af5-9592-229ec371f192][2023-09-08]]',
    '[[2023-09-09 Saturday]]': '[[id:9f97f158-bbb1-484f-9c25-467f0bf7b979][2023-09-09]]',
    '[[2023-09-11 Monday]]': '[[id:6adbcd53-419e-4283-ac0f-f6e5fb585efb][2023-09-11]]',
    '[[2023-09-12 Tuesday]]': '[[id:bfa1bde7-f856-462e-9c1e-5d9b757e7743][2023-09-12]]',
    '[[2023-09-13 Wednesday]]': '[[id:07743ae9-ada4-4376-b991-3bc75ba1add2][2023-09-13]]',
    '[[2023-09-15 Friday]]': '[[id:43db7705-6a2e-4d4f-8f67-e0fa33ebda33][2023-09-15]]',
    '[[2023-09-16 Saturday]]': '[[id:6f193995-d7cc-4e72-9195-1ff0c00f551c][2023-09-16]]',
    '[[2023-09-18 Monday]]': '[[id:f76e44ae-b347-43f2-83c2-848ad05214a0][2023-09-18]]',
    '[[2023-09-17 Saturday]]': '[[id:15403a59-7388-437e-b114-2ccd9481b7ff][2023-09-17]]',
    '[[2023-09-10 Sunday]]': '[[id:0acd0499-7884-4c3f-9597-bcca7be0f014][2023-09-10]]',
    '[[2023-09-14 Thursday]]': '[[id:7c0dff76-35d7-4009-9bd2-6c101881ad25][2023-09-14]]'
}


def main():
    cmd = sys.argv[1]
    targets = sys.argv[2:]

    if cmd == 'search':
        page_ref_pattern = r'\[\[[a-zA-Z0-9\s\/-]*\]\]'
        block_ref_pattern = r'\(\([a-zA-Z0-9\s\/-]*\)\)'
        counter = collections.Counter()
        entry2file = {}

        for target in targets:
            with open(target, 'r') as f:
                text = '\n'.join(f.readlines())

            for p in (page_ref_pattern, block_ref_pattern):
                matches = re.findall(p, text)
                counter.update(matches)
                for m in matches:
                    if m not in entry2file:
                        entry2file[m] = [target]
                    else:
                        entry2file[m].append(target)

        entries = [(k, v) for k, v in counter.items()]
        entries.sort(key=lambda x: x[0])
        for key, count in entries:
            note = '' if key in REPLACE else '(no link)'
            files = ','.join(entry2file.get(key, []))
            print(f'{count:2d} {key:45s} {note:10s}: {files}')

    elif cmd == 'replace':
        for target in targets:
            print(f'> {target}')
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
