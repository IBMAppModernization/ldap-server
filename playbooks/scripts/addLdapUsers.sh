#!/bin/bash
usage () {
  echo "Usage:"
  echo "addLdapUsers.sh LDAP_BIND_PASSWORD"
}

# number of parameters
if [ "$#" -ne 1 ]
then
    usage
    exit 1
fi

LDAP_BIND_PASSWORD=$1

ldapadd -x -w $LDAP_BIND_PASSWORD -D "cn=admin,dc=clouddragons,dc=com" -f /etc/openldap/users.ldif 
if [ $? -eq 0 ]; then
  echo "Users added successfully" > /etc/openldap/user-status.txt
fi
