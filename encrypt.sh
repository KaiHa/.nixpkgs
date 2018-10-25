#!/usr/bin/env bash

selfdir=$(dirname $(readlink -f $0))

aescrypt -e -p "$(gpg --decrypt "$selfdir/secret.gpg" | sed 's/"//g' )" -o $1.aes $1
