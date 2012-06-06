#!/bin/bash

if [ $# -ne 1 ]
then
  echo "Usage: $0 <server-hostname>"
  exit 1
fi

instance_files=$(dirname $0)/instance-files
scp -i $EC2_KEYPAIR_PK -o User=$EC2_DEFAULT_LOGIN  -r $instance_files/* $instance_files/.??* $1:~
