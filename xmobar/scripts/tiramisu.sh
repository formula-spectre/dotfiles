#!/bin/bash

 # tiramisu -j |
 #     while read -r noti; do
 #       echo "$noti" | jq -r --unbuffered '.source+" "+.summary+" "+.body' | cut -c1-50
 #       herbe "$(echo "$noti" |jq -r --unbuffered '.source,.summary,.body' )" &
 #     done

cat /tmp/noti-log
# tiramisu -o "#sourceNEW_LABEL#summaryNEW_LABEL#body" |
#      while read -r noti; do
#       echo "$noti" | sed 's/NEW_LABEL/\ /g' | cut -c1-50
#        herbe "$(echo "$noti" | sed 's/NEW_LABEL/\n/')"
#       done
