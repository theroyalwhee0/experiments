#!/usr/bin/env bash

lock_file_timeout() {
  local lock_file="$1"
  local timeout="${2:-10}"
	local lock_id="${3:-200}"
  flock --timeout "${timeout}" --exclusive "${lock_id}"
}

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

LKF="./lock.txt";(
  while ! (wait_file './exists.txt' 10 && lock_file_timeout "${LCK}" 10); do
    echo "Still waiting."
  done
) 200>"${LKF}";LKF=

