#!/bin/sh
#[ -e /tmp/metroplex ] || touch /tmp/metroplex

if ( lsusb | grep HHKB > /dev/null);
then
    echo online
else
    echo offline
fi
