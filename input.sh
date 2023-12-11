#!/usr/bin/sh
set -e
if [ -z "$2" ]
then
    year=$(date '+%Y')
else
    year="$2"
fi
if [ -z "$1" ]
then
    day=$(TZ=':US/Eastern' date '+%-d')
else
    day="$1"
fi
session_path="$(dirname $0)/session"
session=$(cat "$session_path")
set -x
curl -H "Cookie: session=$session" "https://adventofcode.com/${year}/day/${day}/input" > "d${day}.in"
