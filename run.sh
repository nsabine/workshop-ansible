#!/usr/bin/env bash

if [ ${#} -ne 1 ]
then
    echo "specify number of instances"
    exit 1
fi

printf "Refreshing EC2 cache..."
./inventory/aws/hosts/ec2.py --refresh-cache
printf "done\n"

ssh-add -l >/dev/null 2>&1
if [ "${?}" == "0" ]
then
    ansible-playbook -v -i inventory/aws/hosts/ec2.py \
                     --extra-vars "instances=${1}" \
                     workshop.yaml
else
    echo "You must run this with ssh-agent holding a key via ssh-add"
    exit 1
fi