#!/bin/bash

echo Set up key and trust stores for ActiveMQ, NVR and Cloud Server
echo The personal and geographic information you enter will be used on both the client and broker certs.
echo
kspassword_broker=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 40)
kspassword_client=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 40)
tspassword_client=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 40)
cloudUserPassword=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 40)
declare -r u="[Unknown]"
while : ; do
  echo Enter the distinguished name. Provide a single dot \(.\) to leave a sub-component empty or press ENTER to use the default value \[Unknown\].

  read -rp "What is your first and last name? " cn
  cn=${cn:-$u}
  read -rp "What is the name of your organizational unit? " ou
  ou=${ou:-$u}
  read -rp "What is the name of your organization? " o
  o=${o:-$u}
  read -rp "What is the name of your City or Locality? " c
  c=${c:-$u}
  read -rp "What is the name of your State or Province? " st
  st=${st:-$u}
  echo -n "Is CN=$cn, OU=$ou, O=$o, C=$c, ST=$st correct? [no] "
  read -r ans
  if [ ${ans,,} == "yes" ]
  then
    break
  fi
done
keytool -genkey -alias broker -dname "cn=$cn, ou=$ou, o=$o, c=$c st=$st" -keypass "$kspassword_broker" -storepass "$kspassword_broker" -keyalg RSA -keystore broker.ks
keytool -export -alias broker -storepass "$kspassword_broker" -keystore broker.ks -file broker_cert
keytool -genkey -alias client -dname "cn=$cn, ou=$ou, o=$o, c=$c st=$st" -keypass "$kspassword_client" -storepass "$tspassword_client" -keyalg RSA -keystore client.ks
keytool -import -noprompt -alias broker -storepass "$kspassword_client" -keystore client.ts -file broker_cert

# Put the broker keystore in Active MQ config directory
mv broker.ks ../deb-file-creation/conf

# Update the password in the activemq.xml config file
xml ed -N x="http://activemq.apache.org/schema/core" -u "//x:plugins/x:simpleAuthenticationPlugin/x:users/x:authenticationUser[@username='cloud']/@password" -v "$cloudUserPassword" ../deb-file-creation/conf/activemq.xml > tmp.xml
xml ed -N x="http://activemq.apache.org/schema/core" -u "//x:sslContext/x:sslContext[@keyStore='file:conf/broker.ks']/@keyStorePassword" -v "$kspassword_broker" tmp.xml > newfile.xml
rm tmp.xml
mv newfile.xml ../deb-file-creation/conf/activemq.xml
