#!/bin/sh
trap true USR1
tiramisu -o "#sourceNEW_LABEL#summaryNEW_LABEL#body" |
    while read -r noti; do
      echo "$noti" | sed 's/NEW_LABEL/\ /g' | cut -c1-50
      herbe "$(echo "$noti" | sed 's/NEW_LABEL/\n/g')" &
    done
