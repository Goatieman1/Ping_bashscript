#!/bin/bash

#-----Set IP addresses here-------------
PING1=0.0.0.0 
PING2=0.0.0.0
PING3=0.0.0.0
#---------------------------------------

check_response() #response codes are the following 0=reachable 1=unreachable
{
    local TIME1=$(date +"%A %d %B %Y (%r)")
    echo -e "\n###Date of check $TIME1###\n"

    FIRST_PING=$(ping -c 1 "$PING1" ; echo $?)
    FIRST_RESULT=${FIRST_PING: -1}
    if [ $FIRST_RESULT -gt 0 ]
    then
        echo "Host Unreachable with exit code ${FIRST_PING: -1}"
    else
        echo "Host Reachable with exit code ${FIRST_PING: -1}"
    fi

    SECOND_PING=$(ping -c 1 "$PING2" ; echo $?)
    SECOND_RESULT=${SECOND_PING: -1}
    if [ $SECOND_RESULT -gt 0 ]
    then
        echo "Host Unreachable with exit code ${SECOND_PING: -1}"
    else
        echo "Host Reachable with exit code ${SECOND_PING: -1}"
    fi

    THIRD_PING=$(ping -c 1 "$PING3" ; echo $?)
    THIRD_RESULT=${THIRD_PING: -1}
    if [ $THIRD_RESULT -gt 0 ]
    then
        echo "Host Unreachable with exit code ${THIRD_PING: -1}"
    else
        echo "Host Reachable with exit code ${THIRD_PING: -1}"
    fi
}

usage() {
    cat <<EOF
Usage: $0 [--interval <seconds>] [--once]

  --interval <seconds>  Set delay between checks (default: 300). Must be a positive integer.
  --once                Run a single check and exit instead of looping.
EOF
}

INTERVAL=300
RUN_ONCE=false

while [ $# -gt 0 ]
do
    case "$1" in
        --interval)
            if [ -z "$2" ]; then
                echo "Error: --interval requires a value." >&2
                usage
                exit 1
            fi
            INTERVAL="$2"
            shift 2
            ;;
        --once)
            RUN_ONCE=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Error: Unknown option $1" >&2
            usage
            exit 1
            ;;
    esac
done

if ! echo "$INTERVAL" | grep -Eq '^[1-9][0-9]*$'; then
    echo "Error: Interval must be a positive integer (seconds)." >&2
    usage
    exit 1
fi

#Creates file if does not exist
touch results_ping.txt

#Updating log file and providing feedback to terminal
if [ "$RUN_ONCE" = true ]; then
    echo "Writing to log file"
    check_response >> results_ping.txt
    echo "Check log file results_ping.txt"
else
    while true
    do
        echo "Writing to log file"
        check_response >> results_ping.txt
        echo "Check log file results_ping.txt"
        sleep "$INTERVAL"
    done
fi

exit 0
