#!/bin/bash

source "$(dirname $(realpath $0))/chat_config.bash"

XML_FILE=$(mktemp)
trap "rm -f ${XML_FILE}" EXIT

curl https://meigen.doodlenote.net/api/ \
     -s \
     -o ${XML_FILE}

curl -X POST ${INCOME_URL} \
     -s \
     -H 'Content-Type: application/json' \
     -d @- <<EOF
{
  "username": "今日の名言",
  "icon_emoji": "robot",
  "attachments": [
    {
      "text": "$(ggrep -ioP '(?<=<meigen>).*(?=</meigen>)' ${XML_FILE})",
      "footer": "$(ggrep -ioP '(?<=<auther>).*(?=</auther>)' ${XML_FILE})"
    }
  ]
}
EOF
