#! /usr/bin/env bash

set -e

source .env

sshpass -p "$HW6_USER_PWD" \
    scp \
    detail/for_spark.csv \
    detail/create_xtable.bash \
    "$HW6_USER@$HW6_HOST_PUBLIC_IP:/home/$HW6_USER/team-5-data"

sshpass -p "$HW6_USER_PWD" \
    ssh \
    -t \
    "$HW6_USER@$HW6_HOST_PUBLIC_IP" \
    "/bin/bash -l -c /home/$HW6_USER/team-5-data/create_xtable.bash"
