#!/bin/bash

if [[ $NGPVAN_MODE != 'MyCampaign' && $NGPVAN_MODE != 'VoterFile' ]]; then
  echo "ERROR - NGPVAN_MODE value: ${NGPVAN_MODE} must be either 'MyCampaign' or 'VoterFile'"
  return 1
else
  if [[ $NGPVAN_MODE == 'MyCampaign' ]]; then
    NGPVAN_MODE='0'
  elif [[ $NGPVAN_MODE == 'VoterFile' ]]; then
    NGPVAN_MODE='1'
  fi
fi

HOST='https://api.securevan.com/v4'
AUTH="${NGPVAN_APPLICATION_NAME}:${NGPVAN_API_KEY}|${NGPVAN_MODE}"

function hit_api(){
  verb=$1
  endpoint=$2
  body=$3
  if [ -z "$3" ]; then
    status=$(curl -u $AUTH -s -o response.json -w "%{http_code}\\n" -k -X ${verb} "${HOST}${endpoint}")
  else
    status=$(echo "${body}" | curl -u $AUTH -s -o response.json -w "%{http_code}\\n" -k -X ${verb} "${HOST}${endpoint}" -d @- -H "Content-Type: application/json")
  fi
  debug "$(cat response.json)"
  echo $status
}

function debug(){
  if [ $DEBUG ]; then
    echo "$@" >&2
  fi
}

function test_connection() {
  test_msg='{"message":"test"}'
  status=$(hit_api 'POST' '/echoes' $test_msg)
  if [[ "$status" -ne 200 ]]; then
    echo "ERROR! Got response code: $status"
    return 1
  else
    echo "Successfully connected"
  fi
}
