#!/usr/bin/env bash

lock_file_forever() {
  local lock_file="$1"
  local lock_id="${2:-200}"
  flock --exclusive "${lock_id}"
}

lock_file_timeout() {
  local lock_file="$1"
  local timeout="${2:-10}"
	local lock_id="${3:-200}"
  flock --timeout "${timeout}" --exclusive "${lock_id}"
}


LKF="./lock.txt";(
  echo "Start"
  lock_file_forever $LKF
  echo "Sleeping"
  sleep 10
  echo "End"
) 200>"${LKF}";LKF=

# LKF="./lock.txt";(
#   while ! lock_file_timeout "${LCK}" 10; do
#     echo "Still waiting."
#   done
# ) 200>"${LKF}";LKF=

