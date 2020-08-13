# External LDAP for IBM Client Dev Advocacy Workshops

This repo contains an ansible playbook for installing and configuring the following on a VM with CentOS 7 or RHEL 7:

An OpenLDAP server with a set of users, groups and passwords.

  * Latest available version in the yum repo is installed

  * Two groups are created: *admins* and *developers*
      * Members of the *admins* group will be Jenkins super users
          - One member of this group will be created - *suser001*
      * Members of the *developers* will be Jenkins regular users
          - 40 members of this group will be created with usernames in the range:  *user001 - user040*
      * **Manager DN** is `cn=admin,dc=clouddragons,dc=com`
      * **External LDAP port** is `389`
      * **Fully qualified user name** is like `uid=user001,ou=users,dc=clouddragons,dc=com`
      * **Fully qualified group name** is like `cn=developers,ou=groups,dc=clouddragons,dc=com`
      * **Group membership is like** `member: uid=user001,ou=users,dc=clouddragons,dc=com`
      * **Group objectClass is** `groupOfNames`
      * **User objectClass is** `inetOrgUser`



## Prerequisites

1. A clone of this repo on your local machine.

1. A local installation of [ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html). **Note:** The playbook was tested with *ansible 2.9.2* on *macOS Mojave*.

1. A Virtual Server Instance of CentOS 7 RHEL 7 running on IBM Cloud with passwordless SSH  from your local machine set for the *root* user.


## Running the playbook

1. Edit the file [inventory/hosts](inventory/hosts) and add the following:

    * A bind password for the LDAP server. This will be set when OpenLDAP is configured by the playbook

    ```
    # Set this to the LDAP bind password you want to use
    ldap_bind_password=yourverysecurebindpassword
    ```

    * The IP address of your CentOS 7 or RHEL 7 VSI

    ```
    # Add external IP address of provisioned CentOS 7  or RHEL 7 VSI
    [ldapvm]
    10.10.10.10
    ```

2. Run the following command from the base directory of this cloned repo

```
ansible-playbook  -i inventory/hosts playbooks/site.yml

```

## Post install setup

1. Open the file **users.csv** in the **users** subfolder of the base directory of this cloned repo. The first line of the file will have the *suser001* user and the password. The remaining lines will be the users *user001 - user040* and their respective passwords. **Note:** if you run the playbook again and this file is present,  a fresh set of passwords will not be generated.
