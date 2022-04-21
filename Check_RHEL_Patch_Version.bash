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



