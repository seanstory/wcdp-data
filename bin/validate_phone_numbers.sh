#!/bin/bash

source "$(dirname $0)/keys.sh"
set -e

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


function hit_api(){
  verb=$1
  endpoint=$2
  body=$3
  if [ -z $3 ]; then
    status=$(curl -u $AUTH -s -o response.json -w "%{http_code}\\n" -k -X ${verb} "${HOST}${endpoint}")
  else
    status=$(echo $body | curl -u $AUTH -s -o response.json -w "%{http_code}\\n" -k -X ${verb} "${HOST}${endpoint}" -d @- -H "Content-Type: application/json")
  fi
  debug "$(cat response.json)"
  echo $status
}

function debug(){
  if [ $DEBUG ]; then
    echo "$@" >&2
  fi
}


if [ -z $NGPVAN_API_KEY ]; then
  echo "What is your NGP/VAN API KEY? (Example: 93dd837b-8gg7-095e-2640-a846ae11ed65)"
  read NGPVAN_API_KEY
fi
if [ -z $NGPVAN_APPLICATION_NAME ]; then
  echo "What is your Application Name? (Example: demo.derp.api)"
  read NGPVAN_APPLICATION_NAME
fi
if [ -z $NGPVAN_MODE ]; then
  echo "What is your Host? (Example: workplace-search-1.ea-eden-3-staging.elastic.dev)"
  read NGPVAN_MODE
fi
NGPVAN_API_KEY=`echo $NGPVAN_API_KEY | tr -d '[:blank:]'`
NGPVAN_APPLICATION_NAME=`echo $NGPVAN_APPLICATION_NAME | tr -d '[:blank:]'`
NGPVAN_MODE=`echo $NGPVAN_MODE | tr -d '[:blank:]'`

if [[ $NGPVAN_MODE != 'MyCampaign' && $NGPVAN_MODE != 'VoterFile' ]]; then
  echo "ERROR - NGPVAN_MODE value: ${NGPVAN_MODE} must be either 'MyCampaign' or 'VoterFile'"
  exit 1
else
  if [[ $NGPVAN_MODE == 'MyCampaign' ]]; then
    NGPVAN_MODE='0'
  elif [[ $NGPVAN_MODE == 'VoterFile' ]]; then
    NGPVAN_MODE='1'
  fi
fi

HOST='https://api.securevan.com/v4'
AUTH="${NGPVAN_APPLICATION_NAME}:${NGPVAN_API_KEY}|${NGPVAN_MODE}"

test_connection


# cleanup
rm response.json
