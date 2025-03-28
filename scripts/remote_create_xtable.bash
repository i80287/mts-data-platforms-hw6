#! /usr/bin/env bash

set -e

source .env

data_folder=/home/$HW6_USER/team-5-data

echo "> Creating $data_folder on the remote host if not exists..."
sshpass -p "$HW6_USER_PWD" \
    ssh \
    -t \
    "$HW6_USER@$HW6_HOST_PUBLIC_IP" \
    "mkdir -p $data_folder"

echo "> Loading files to the remote host..."
sshpass -p "$HW6_USER_PWD" \
    scp \
    .env \
    detail/for_spark.csv \
    detail/create_xtable.bash \
    "$HW6_USER@$HW6_HOST_PUBLIC_IP:$data_folder/"

echo "> Executing $data_folder/create_xtable.bash on the remote host..."
sshpass -p "$HW6_USER_PWD" \
    ssh \
    -t \
    "$HW6_USER@$HW6_HOST_PUBLIC_IP" \
    "/bin/bash -l -c \"cd $data_folder && ./create_xtable.bash\""
