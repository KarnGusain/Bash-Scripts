#!/bin/bash
printf "\n"
marker=$(printf "%0.s-" {1..68})
printf "|$marker|\n"
printf "| %-25s | %-38s |\n" "IP Address" "Hostname"
printf "|$marker|\n"
while read -r host; do
    result=$(nslookup $host | awk '/name = /{print $4}')
    printf "| %-25s | %-38s |\n" "$host" "${result:-no dns record}"
done < all_ips
printf "|$marker|\n"
