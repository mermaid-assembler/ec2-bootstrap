#!/bin/bash

work_size=50 # 4 * $work_size should be size of /work
ec2-run-instances ami-4fad7426 -k cancer -t cc1.4xlarge -b "/dev/sdb=:$work_size" -b "/dev/sdc=:$work_size" -b "/dev/sdd=:$work_size" -b "/dev/sde=:$work_size"
