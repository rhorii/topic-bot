#!/bin/bash

CONFIG_FILE="$(dirname $(realpath $0))/chat.conf"

if [[ -f ${CONFIG_FILE} ]]; then
  source ${CONFIG_FILE}
fi

if [[ -z "${INCOME_URL}" ]]; then
  read -p 'INCOME_URL: ' INCOME_URL
fi
