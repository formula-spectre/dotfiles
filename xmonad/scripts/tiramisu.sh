#!/bin/sh
trap true USR1
tiramisu -j |
    while read -r noti; do
      echo "$noti" | jq -r '.source+" "+.summary+" "+.body' | cut -c1-50
      herbe "$(echo "$noti" |jq -r --unbuffered '.source,.summary,.body' )" &
    done
