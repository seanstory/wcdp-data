#!/bin/bash

source "$(dirname $0)/keys.sh"
set -e

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

source "$(dirname $0)/functions.sh"

test_connection


# cleanup
rm response.json
