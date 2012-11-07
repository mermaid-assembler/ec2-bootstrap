#!/bin/bash

# Basic packages
apt-get update
apt-get install -y build-essential git
apt-get install -y s3cmd

# Meraculous dependencies
apt-get install -y perl blast2 libboost-dev swig1.3

curl -L http://cpanmin.us | perl - --sudo App::cpanminus
cpanm --force Bundle::CPAN
cpanm --force Log::Log4perl
cpanm --force Date/Calc.pm
cpanm --force XMLRPC::Lite

#yes "" | perl -MCPAN -e "install Bundle::CPAN" # This won't run automatically because Perl is bad
#yes "" | perl -MCPAN -e "install Log::Log4perl"
#yes "" | perl -MCPAN -e "install 'Date/Calc.pm'"
#yes "" | perl -MCPAN -e "install XMLRPC::Lite"

# Mermaid dependencies
apt-get install -y openmpi-bin libopenmpi-dev libboost-mpi-dev libboost-filesystem-dev
wget http://sparsehash.googlecode.com/files/sparsehash_2.0.2-1_i386.deb
dpkg -i sparsehash_2.0.2-1_i386.deb
rm sparsehash_2.0.2-1_i386.deb

# For RAID
# Installing mdadm recommends postfix as a dependency...
# which has a stupid GUI installer...
apt-get install --no-install-recommends -y mdadm
apt-get install -y xfsprogs

# FIXME: Fix the RAID array naming issue
# lots of info here: https://bugzilla.redhat.com/show_bug.cgi?id=606481
mdadm --create /dev/md0 --level=0 -c64 --raid-devices=4 /dev/xvdb /dev/xvdc /dev/xvdd /dev/xvde
echo 'DEVICE /dev/xvdb /dev/xvdc /dev/xvdd /dev/xvde' > /etc/mdadm/mdadm.conf
mdadm --detail --scan >> /etc/mdadm/mdadm.conf

mkfs.xfs -l internal,lazy-count=1,size=128m -d su=64k,sw=4 /dev/md0

uuid=$(mdadm --detail --scan | grep -o "UUID=\(.*\)" | cut -d"=" -f2)
echo "/dev/disk/by-id/md-uuid-${uuid} /work xfs defaults 0 0" >> /etc/fstab

mkdir /work
mount /dev/md0 /work
chown ubuntu:ubuntu /work

sudo -i -u ubuntu ./install_cancer_ubuntu.sh
