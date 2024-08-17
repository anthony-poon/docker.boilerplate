#!/usr/bin/env bash

ssh-keygen -t ed25519 -f ./var/ssh/ssh_host_ed25519_key -q -N "" < /dev/null
ssh-keygen -t rsa -b 4096 -f ./var/ssh/ssh_host_rsa_key -q -N "" < /dev/null