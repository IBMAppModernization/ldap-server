#!/bin/bash
usage () {
  echo "Usage:"
  echo "ldapConfig.sh LDAP_BIND_PASSWORD"
}

# number of parameters
if [ "$#" -ne 1 ]
then
    usage
    exit 1
fi

LDAP_BIND_PASSWORD=$1

# Generate LDAP password from a secret key
slappasswd -h {SSHA} -s $LDAP_BIND_PASSWORD -n > /etc/openldap/passwd


ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f /etc/openldap/schema/cosine.ldif > /dev/null  2>&1

ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f /etc/openldap/schema/nis.ldif > /dev/null  2>&1

ldapadd -Y EXTERNAL -H ldapi:/// -D "cn=config" -f /etc/openldap/schema/inetorgperson.ldif  > /dev/null  2>&1


cat > /etc/openldap/configChanges.ldif << EOF
dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcSuffix
olcSuffix: dc=clouddragons,dc=com

dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcRootDN
olcRootDN: cn=admin,dc=clouddragons,dc=com

dn: olcDatabase={2}hdb,cn=config
changetype: modify
replace: olcRootPW
olcRootPW: $(</etc/openldap/passwd)


dn: cn=config
changetype: modify
replace: olcLogLevel
olcLogLevel: -1

dn: olcDatabase={1}monitor,cn=config
changetype: modify
replace: olcAccess
olcAccess: {0}to * by dn.base="gidNumber=0+uidNumber=0,cn=peercred,cn=external,cn=auth" read by dn.base="cn=admin,dc=clouddragons,dc=com" read by * none
EOF

ldapmodify -Y EXTERNAL -H ldapi:/// -f /etc/openldap/configChanges.ldif > /dev/null  2>&1

# Restart OpenLDAP
systemctl restart slapd
