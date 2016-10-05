#!/bin/bash

#Created by mhassan772
#Usage: ./zone_transfer domain.com

#Get the DNS server using whois
#$1 = the domain
DNS=`whois $1 | grep "Name Servers:" -A 1 | xargs -L2 | cut -d' ' -f3`


echo "The DNS the script will use is: "$DNS
echo "Trying Zone Transfer.."

#trying zone transfer using dig
dig axfr @$DNS $1
