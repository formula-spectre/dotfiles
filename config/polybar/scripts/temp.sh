#!/bin/bash
#while [ true ]
#do
  temp=$(cat /sys/class/thermal/thermal_zone0/temp | cut -d '0' -f1)
  temperature=${temp:0:2} 
  echo $temperature
#sleep 5
#done
