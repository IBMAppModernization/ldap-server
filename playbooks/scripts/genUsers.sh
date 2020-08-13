#!/bin/bash
# Generates a .csv file with users suser001, user001-user040 and random 8 char passwords
export LC_ALL=C
CURRENTDIR=$(dirname $0)
USERDIR=`cd $CURRENTDIR/../../users && pwd`
USERFILE=$USERDIR/users.csv
NEWPWD=$(cat /dev/urandom | tr -dc 'a-np-zA-NP-Z1-9' | fold -w 8 | head -n 1)

# Admin user suser001
echo "suser001,$NEWPWD"  > $USERFILE

# Regular users
# user001 to user040
for i in $(seq 40)
do
  NEWPWD=$(cat /dev/urandom | tr -dc 'a-np-zA-NP-Z1-9' | fold -w 8 | head -n 1)
  printf -v USERNAME "user%03d" $i
  echo "$USERNAME,$NEWPWD"  >> $USERFILE
done
