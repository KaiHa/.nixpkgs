#!/usr/bin/env bash

selfdir=$(dirname $(readlink -f $0))

aescrypt -e -p "$(sed 's/"//g' $selfdir/secret)" -o $1.aes $1
