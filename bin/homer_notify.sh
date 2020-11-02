#!/bin/bash

count=0
retries=10
sleepy=1

# Some time the random message is not a valid payload, CBFd fixing that so try again with exponential backoff
while [ $count -lt $retries ]
do
    HOMER_QUOTE=`homer.sh`
    curl -s -S -f -X POST -H 'Content-type: application/json' --data '{"text":"> “'"${HOMER_QUOTE}"'”\n'"${1}"'"}' $2 > /dev/null

    if [ $? -eq 0 ]
    then
        break
    else
        sleep $sleepy
        let sleepy*=2
        let count+=1
    fi
done
