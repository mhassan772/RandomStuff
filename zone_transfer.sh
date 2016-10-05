#!/bin/bash

#Created by mhassan772
#Usage: ./zone_transfer domain.com

DNS=`whois $1 | grep "Name Servers:" -A 1 | xargs -L2 | cut -d' ' -f3`


echo "The DNS the script will use is: "$DNS
echo "Trying Zone Transfer.."
dig axfr @$DNS $1
