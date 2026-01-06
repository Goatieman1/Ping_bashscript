#!/bin/bash

#-----Set IP addresses here-------------
DEFAULT_HOSTS=("0.0.0.0" "0.0.0.0" "0.0.0.0")
#---------------------------------------

HOSTS_INPUT="${HOSTS:-}"

while [[ $# -gt 0 ]]
do
case "$1" in
    --hosts)
    shift
    HOSTS_INPUT="$1"
    shift
    ;;
    *)
    echo "Unknown option: $1"
    echo "Usage: $0 [--hosts \"host1,host2,host3\"]"
    exit 1
    ;;
esac
done

if [ -z "$HOSTS_INPUT" ]; then
    HOST_LIST=("${DEFAULT_HOSTS[@]}")
else
    IFS=', ' read -r -a HOST_LIST <<< "${HOSTS_INPUT//,/ }"
fi

if [ ${#HOST_LIST[@]} -eq 0 ]; then
    echo "No hosts provided."
    exit 1
fi

check_response() #response codes are the following 0=reachable 1=unreachable
{
TIME1=`date +"%A %d %B %Y (%r)"`
echo -e "\n###Date of check $TIME1###\n"

for HOST in "${HOST_LIST[@]}"
do
    ping -c 1 "$HOST" > /dev/null 2>&1
    RESULT=$?
    if [ $RESULT -gt 0 ]
    then
        echo "Host $HOST Unreachable with exit code $RESULT"
    else
        echo "Host $HOST Reachable with exit code $RESULT"
    fi
done
}

#Creates file if does not exist
touch results_ping.txt

#Updating log file and providing feedback to terminal
while true
do
echo "Writing to log file"
check_response >> results_ping.txt
echo "Check log file results_ping.txt"
sleep 300
done

exit $?
