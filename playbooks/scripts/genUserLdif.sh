#!/bin/bash
# Generates aa ldif file with all the users
USERFILE=/etc/openldap/users.csv
USERLDIF=/tmp/users.ldif

csvinput=$USERFILE

## Build the users ou
echo "dn: ou=users,dc=clouddragons,dc=com" > $USERLDIF
echo "ou: users" >> $USERLDIF
echo "objectClass: organizationalUnit" >> $USERLDIF
echo  >> $USERLDIF

while IFS="," read -r username password
do
     echo "dn: uid=$username,ou=users,dc=clouddragons,dc=com" >> $USERLDIF
     lastname=$(echo $username | awk '{print toupper(substr($0,0,1)) tolower(substr($0,2))}' )
     if [[ $username == suser* ]]
     then
        echo "cn: Admin $lastname" >> $USERLDIF
        echo "givenname: Admin" >> $USERLDIF
     else
        echo "cn: Developer $lastname" >> $USERLDIF
        echo "givenname: Developer" >> $USERLDIF
     fi

     echo "uid: $username" >> $USERLDIF
     echo "userpassword: $password" >> $USERLDIF
     echo "mail: $username@clouddragons.com" >> $USERLDIF
     echo "objectclass: person" >> $USERLDIF
     echo "objectclass: inetOrgPerson" >> $USERLDIF
     echo "objectclass: top" >> $USERLDIF
     echo "sn: $lastname" >> $USERLDIF
     echo  >> $USERLDIF

     if [[ $username == suser* ]]
     then
        echo "dn: cn=admins,ou=groups,dc=clouddragons,dc=com" >> $USERLDIF
     else
        echo "dn: cn=developers,ou=groups,dc=clouddragons,dc=com" >> $USERLDIF
     fi
     echo "changetype: modify" >> $USERLDIF
     echo "add: uniquemember" >> $USERLDIF
     echo "uniquemember: uid=$username,ou=users,dc=clouddragons,dc=com" >> $USERLDIF
     echo >> $USERLDIF
done < "$csvinput"

mv $USERLDIF /etc/openldap
