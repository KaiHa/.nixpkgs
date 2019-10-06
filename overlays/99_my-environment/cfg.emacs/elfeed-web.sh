#!/usr/bin/env bash

set -e

action=${1}
elfeed_port=49080
rule_num=3

if [[ "$action" = start ]]; then
    sudo iptables -w -I nixos-fw $rule_num -p tcp --dport $elfeed_port -j nixos-fw-accept
    emacsclient -e '(elfeed-web-start)'
elif [[ "$action" = stop ]]; then
    sudo iptables -w -D nixos-fw -p tcp --dport $elfeed_port -j nixos-fw-accept
    emacsclient -e '(elfeed-web-stop)'
else
    echo "error: unknown action" >&2
    echo "usage: $(basename $0) (start|stop)"
fi
