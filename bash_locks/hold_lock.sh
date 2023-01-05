#!/usr/bin/env bash
LCK=$1;(
  flock --exclusive 201
  sleep 1d
) 201>"${LCK}"
