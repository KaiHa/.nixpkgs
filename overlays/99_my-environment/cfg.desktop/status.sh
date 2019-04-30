#!/usr/bin/env bash

i=0

i3status | while :
do
    read line
    mail_count=$(notmuch count tag:inbox and tag:unread)
    if [[ $mail_count -ge 1 ]]; then
        mail={\"name\":\"mails\",\"color\":\"\#FFFF00\",\"markup\":\"none\",\"full_text\":\"📨$mail_count\"},
    else
        mail=""
    fi

    if [[ $i -le 2 ]]; then
        echo "$line"
    else
        echo ",[${mail}${line:2}" || exit 1
    fi
    i=$(($i + 1))
done
