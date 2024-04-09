#!/bin/bash

echo Set up key and trust stores for ActiveMQ, NVR and Cloud Server
echo The personal and geographic information you enter will be used on both the client and broker certs.
echo
while : ; do
  read -rsp "Enter broker keystore password: " kspassword_broker
  echo
  read -rsp "Re-enter new password: " confirmkspassword_broker
  echo
  if [ "$kspassword_broker" != "$confirmkspassword_broker" ];
  then
    echo Passwords, don\'t match, please re-enter
  elif [ ${#kspassword_broker} -lt 6 ]
  then
    echo You must entrer a password of at least 6 characters
  else
    break
  fi
done
while : ; do
  read -rsp "Enter client keystore password: " kspassword_client
  echo
  read -rsp "Re-enter new password: " confirmkspassword_client
  echo
  if [ "$kspassword_client" != "$confirmkspassword_client" ];
  then
    echo Passwords, don\'t match, please re-enter
  elif [ ${#kspassword_client} -lt 6 ]
  then
    echo You must enter a password of at least 6 characters
  else
    break
  fi
done
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


