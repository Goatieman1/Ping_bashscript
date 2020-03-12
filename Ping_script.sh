#!/bin/bash

#-----Set IP addresses here-------------
PING1=0.0.0.0 
PING2=0.0.0.0
PING3=0.0.0.0
#---------------------------------------
TIME1=`date +"%A %d %B %Y (%r)"`
#---------------------------------------

check_response() #response codes are the following 0=reachable 1=unreachable
{
echo -e "\n###Date of check $TIME1###\n"

FIRST_PING=$(ping -c 1 $PING1 ; echo $?)
FIRST_RESULT=${FIRST_PING: -1}
if [ $FIRST_RESULT -gt 0 ]
then
    echo "Host Unreachable with exit code ${FIRST_PING: -1}"
else
    echo "Host Reachable with exit code ${FIRST_PING: -1}"
fi

SECOND_PING=$(ping -c 1 $PING2 ; echo $?)
SECOND_RESULT=${SECOND_PING: -1}
if [ $SECOND_RESULT -gt 0 ]
then
    echo "Host Unreachable with exit code ${SECOND_PING: -1}"
else
    echo "Host Reachable with exit code ${SECOND_PING: -1}"
fi

THIRD_PING=$(ping -c 1 $PING3 ; echo $?)
THIRD_RESULT=${THIRD_PING: -1}
if [ $THIRD_RESULT -gt 0 ]
then
    echo "Host Unreachable with exit code ${THIRD_PING: -1}"
else
    echo "Host Reachable with exit code ${THIRD_PING: -1}"
fi
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
