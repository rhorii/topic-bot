#!/bin/bash

source "$(dirname $(realpath $0))/chat_config.bash"

HTML_FILE=$(mktemp)
trap "rm -f ${HTML_FILE}" EXIT

curl https://kids.yahoo.co.jp/today \
     -s \
     -o ${HTML_FILE}

curl -X POST ${INCOME_URL} \
     -s \
     -H 'Content-Type: application/json' \
     -d @- <<EOF
{
  "username": "今日は何の日？",
  "icon_emoji": "robot",
  "attachments": [
    {
      "title": "$(/opt/homebrew/bin/ggrep -ioP '(?<=<dt><span>).*(?=</span></dt>)' ${HTML_FILE})",
      "text": "$(/opt/homebrew/bin/ggrep -ioP -m1 '(?<=<dd>).*(?=</dd>)' ${HTML_FILE})"
    }
  ]
}
EOF
