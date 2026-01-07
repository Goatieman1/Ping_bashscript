#!/bin/bash

#-----Set IP addresses here-------------
PING1=0.0.0.0
PING2=0.0.0.0
PING3=0.0.0.0
#---------------------------------------

LOG_PATH_DEFAULT="results_ping.txt"
LOG_PATH="${LOG_PATH:-$LOG_PATH_DEFAULT}"
LOG_ENABLED=true

usage() {
  echo "Usage: $0 [--log <file>] [--no-log]"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --log)
      if [[ -z "$2" ]]; then
        echo "Error: --log requires a file path" >&2
        usage
        exit 2
      fi
      LOG_PATH="$2"
      shift 2
      ;;
    --no-log)
      LOG_ENABLED=false
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Error: Unknown argument $1" >&2
      usage
      exit 2
      ;;
  esac
done

log_line() {
  local line="$1"
  echo "$line"
  if [[ "$LOG_ENABLED" == "true" ]]; then
    echo "$line" >> "$LOG_PATH"
  fi
}

handle_exit() {
  local timestamp
  timestamp=$(date +"%Y-%m-%dT%H:%M:%S%z")
  log_line "$timestamp signal=terminated message=Flushing final message before exit"
  exit 130
}

trap handle_exit INT TERM

if [[ "$LOG_ENABLED" == "true" ]]; then
  touch "$LOG_PATH"
fi

HOSTS=($PING1 $PING2 $PING3)

any_unreachable=0

for host in "${HOSTS[@]}"; do
  timestamp=$(date +"%Y-%m-%dT%H:%M:%S%z")
  ping_output=$(ping -c 1 "$host" 2>&1)
  ping_exit=$?

  latency=$(echo "$ping_output" | grep -o 'time=[0-9.]* ms' | awk -F'=' '{print $2}' | head -n 1)

  if [[ $ping_exit -eq 0 ]]; then
    status="reachable"
    if [[ -z "$latency" ]]; then
      latency="unknown"
    fi
  else
    status="unreachable"
    if [[ -z "$latency" ]]; then
      latency="timeout"
    fi
    any_unreachable=1
  fi

  log_line "$timestamp host=$host status=$status latency=$latency"
done

exit $any_unreachable
