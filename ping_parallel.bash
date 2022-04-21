#!/bin/bash
printf "$(date) Starting the Ping Check...."

function pinger() {
    target_host=${1}
    ping -c2 ${target_host} >/dev/null 2>&1 &&
    printf "%-20s %-10s\n" "host ${target_host}" "ping SUCCESS" ||
    printf "%-20s %-10s\n" "host ${target_host}" "ping FAILED"
}
data=$(<new_hosts_0418)
for line in ${data}
do
    pinger ${line} &
done
wait
printf "Completed @=> $(date)"
printf "\n"
