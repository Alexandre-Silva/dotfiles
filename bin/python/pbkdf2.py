#!/usr/bin/env python3

import sys
from passlib.hash import pbkdf2_sha256
from base64 import b64decode
from passlib.utils.binary import ab64_encode
from passlib.hash import django_pbkdf2_sha256


def main(salt, rounds:int):
    print(salt, rounds)

    secret = input('Input password: ')
    hash = django_pbkdf2_sha256.hash(secret, rounds=rounds, salt=salt)

    print(hash)


if __name__ == "__main__":
    main(sys.argv[1], int(sys.argv[2]))
