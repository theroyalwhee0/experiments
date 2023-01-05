#!/usr/bin/env bash

wait_file() {
  # REF: https://superuser.com/questions/878640/unix-script-wait-until-a-file-exists/917073#917073
  local file="$1"; shift
  # 10 seconds as default timeout, pass in -1 for no timeout.
  local wait_seconds="${1:-10}"; shift
  until test $((wait_seconds--)) -eq 0 -o -f "$file" ; do
    sleep 1;
  done
  ((++wait_seconds))
}

# until wait_file "./lock.txt" 5; do
#   echo "Still waiting for file to exist."
# done

# wait_file "./lock.txt" && echo "Got it" || echo "Timed out"
