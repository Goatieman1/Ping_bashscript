#!/bin/bash

#-----Set IP addresses here-------------
PING1=0.0.0.0 
PING2=0.0.0.0
PING3=0.0.0.0
#---------------------------------------

NO_COLOR=""

while [[ $# -gt 0 ]]
do
case "$1" in
    --no-color)
    NO_COLOR=1
    shift
    ;;
    *)
    echo "Unknown option: $1"
    exit 1
    ;;
esac
done

if [[ -t 1 && -z "$NO_COLOR" ]]
then
    COLOR_GREEN="\033[32m"
    COLOR_RED="\033[31m"
    COLOR_BLUE="\033[34m"
    COLOR_RESET="\033[0m"
else
    COLOR_GREEN=""
    COLOR_RED=""
    COLOR_BLUE=""
    COLOR_RESET=""
fi

check_response() #response codes are the following 0=reachable 1=unreachable
{
    local time_of_check success_count=0 failure_count=0
    time_of_check=$(date +"%A %d %B %Y (%r)")

    echo -e "\n${COLOR_BLUE}###Date of check $time_of_check###${COLOR_RESET}\n"

    ping_and_report() {
        local host=$1

        if ping -c 1 "$host" > /dev/null 2>&1
        then
            local exit_code=$?
            echo -e "${COLOR_GREEN}Host $host reachable with exit code $exit_code${COLOR_RESET}"
            ((success_count++))
        else
            local exit_code=$?
            echo -e "${COLOR_RED}Host $host unreachable with exit code $exit_code${COLOR_RESET}"
            ((failure_count++))
        fi
    }

    ping_and_report "$PING1"
    ping_and_report "$PING2"
    ping_and_report "$PING3"

    echo -e "${COLOR_BLUE}Summary: ${success_count} successful, ${failure_count} failed${COLOR_RESET}"
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
