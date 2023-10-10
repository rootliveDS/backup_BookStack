#!/bin/bash


REMOTE_USER='root'                             # Пользователь удаленного дедика 
IP_ADDRESS='45.8.230.193'                      # IP-адрес удаленного дедика


if [ ! -f ~/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -N '' -f ~/.ssh/id_rsa
fi

ssh-copy-id "$REMOTE_USER@$IP_ADDRESS"


