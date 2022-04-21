#!/bin/bash
printf "\n"
marker=$(printf "%0.s-" {1..45})
printf "|$marker|\n"
printf "| %-25s | %-15s |\n" "Hostname" "IP Address"
printf "|$marker|\n"
while read -r host; do
    result=$(nslookup $host |awk '/Address: /{print $2}')
    printf "| %-25s | %-15s |\n" "$host" "${result:-no dns record}"
done <SATLE_HOST_CMDB
printf "|$marker|\n"
