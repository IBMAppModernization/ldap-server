#!/bin/bash
usage () {
  echo "Usage:"
  echo "addLdapBase.sh LDAP_BIND_PASSWORD"
}

# number of parameters
if [ "$#" -ne 1 ]
then
    usage
    exit 1
fi

LDAP_BIND_PASSWORD=$1

cat > /tmp/base.ldif << EOF
dn: dc=clouddragons,dc=com
dc: clouddragons
o: clouddragons
objectClass: dcObject
objectClass: organization
EOF

ldapadd -x -w $LDAP_BIND_PASSWORD -D "cn=admin,dc=clouddragons,dc=com"  -f /tmp/base.ldif

mv /tmp/base.ldif /etc/openldap/base.ldif
