#!/bin/bash

source "$(dirname $(realpath $0))/chat_config.bash"

JSON_FILE=$(mktemp)
trap "rm -f ${JSON_FILE}" EXIT

curl "https://www.jma.go.jp/bosai/amedas/data/map/$(date +'%Y%m%d%H0000').json" \
  -s \
  -o "${JSON_FILE}"

PRESSURE="$(
  cat ${JSON_FILE} | /opt/homebrew/bin/jq '."45212".pressure[0]'
)"
TEMPERATURE="$(
  cat ${JSON_FILE} | /opt/homebrew/bin/jq '."45212".temp[0]'
)"
HUMIDITY="$(
  cat ${JSON_FILE} | /opt/homebrew/bin/jq '."45212".humidity[0]'
)"
WIND="$(
  cat ${JSON_FILE} | /opt/homebrew/bin/jq '."45212".wind[0]'
)"

curl -X POST ${INCOME_URL} \
  -s \
  -H 'Content-Type: application/json' \
  -d @- <<EOS
{
  "username": "アメダス（千葉）",
  "icon_emoji": "robot",
  "attachments": [
    {
      "title": "$(date +'%Y年%m月%d日%H時')",
      "text": "気温: ${TEMPERATURE}℃, 湿度: ${HUMIDITY}%, 風速: ${WIND}m/s, 気圧: ${PRESSURE}hPa"
    }
  ]
}
EOS
