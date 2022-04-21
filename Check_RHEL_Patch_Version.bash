#!/bin/bash
###########
printf "\n"
marker=$(printf "%0.s-" {1..116})
printf "|$marker|\n"
printf "| %-20s | %-15s | %-35s | %-35s |\n"  "Hostname" "RedHat Vesrion" "Kernel Version" "Last Patch"
printf "|$marker|\n"
remote_collect() {
    target_host=$1
    {
        read -r rhelInfo
        read -r kernInfo
        read -r patchInfo
    } < <(
          ssh -i /home/dummy/.ssh/ssh_prod "root@${target_host}" \
              -o StrictHostKeyChecking=no -o PasswordAuthentication=no \
              /bin/bash <<-EOF
              cat /etc/redhat-release | awk 'END{print \$7}'
              rpm -qa --last | awk '/kernel-[0-9]/{ print \$1}'| sed -n 1p
              rpm -qa --last | awk '/kernel-[0-9]/{ first=\$1; \$1=""; print \$0 }'| sed -n 1p
EOF
          ) 2>/dev/null

         if [[ $? -eq 0 ]] ;then
              printf "| %-20s | %-15s | %-35s | %-35s |\n" "${target_host}" "${rhelInfo}" "${kernInfo}" "${patchInfo}"
         else
              printf "| %-20s | %-15s | %-35s | %-35s |\n" "${target_host}" "${rhelInfo:-nologin}" "${kernInfo:-None}" "${patchInfo:-None}"
         fi

} 2>/dev/null
export -f remote_collect
< new_hosts_0418  xargs -P50 -n1 -d'\n' bash -c 'remote_collect "$@"' --
printf "|$marker|\n"


Result

|--------------------------------------------------------------------------------------------------------------------|
| Hostname             | RedHat Vesrion  | Kernel Version                      | Last Patch                          |
|--------------------------------------------------------------------------------------------------------------------|
| fsx2088              | 7.9             | kernel-3.10.0-1160.15.2.el7.x86_64  | Sat 27 Feb 2021 01:28:47 PM IST     |
| fsx0259              | 7.9             | kernel-3.10.0-957.el7.x86_64        | Fri 17 Jul 2020 11:34:52 AM IST     |
| fsx2138              | 7.9             | kernel-3.10.0-1160.36.2.el7.x86_64  | Thu 12 Aug 2021 01:04:10 PM IST     |
| fsx2135              | 7.9             | kernel-3.10.0-1160.21.1.el7.x86_64  | Tue 01 Jun 2021 01:25:26 PM IST     |
| fsx2136              | 7.9             | kernel-3.10.0-1160.36.2.el7.x86_64  | Sat 21 Aug 2021 08:20:04 AM IST     |
| inv0113              | 7.9             | kernel-3.10.0-1160.25.1.el7.x86_64  | Mon 28 Jun 2021 04:47:57 PM IST     |
| fsx5010              | 7.9             | kernel-3.10.0-1160.25.1.el7.x86_64  | Fri 02 Jul 2021 03:12:08 PM IST     |
|--------------------------------------------------------------------------------------------------------------------|
