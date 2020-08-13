#!/bin/bash
usage () {
  echo "Usage:"
  echo "addLdapGroups.sh LDAP_BIND_PASSWORD"
}

# number of parameters
if [ "$#" -ne 1 ]
then
    usage
    exit 1
fi

LDAP_BIND_PASSWORD=$1

cat > /tmp/groups.ldif << EOF
dn: ou=groups,dc=clouddragons,dc=com
objectclass:organizationalunit
ou: groups
description: generic groups branch

dn: cn=developers,ou=groups,dc=clouddragons,dc=com
objectclass: groupofuniquenames
cn: developers
description: Regular users
uniquemember: uid=dummymember,ou=users,dc=clouddragons,dc=com

dn: cn=admins,ou=groups,dc=clouddragons,dc=com
objectclass: groupofuniquenames
cn: admins
description: Admin users
uniquemember: uid=dummymember,ou=users,dc=clouddragons,dc=com
EOF

ldapadd -x -w $LDAP_BIND_PASSWORD -D "cn=admin,dc=clouddragons,dc=com" -f /tmp/groups.ldif
if [ $? -eq 0 ]; then
      echo "Groups added successfully" > /etc/openldap/group-status.txt
fi

mv /tmp/groups.ldif /etc/openldap/groups.ldif
