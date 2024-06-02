#!/bin/bash

export VERSION
VERSION=$(< version.txt)

rm -r activemq-for-cloud-service_*_arm64

mkdir -p activemq-for-cloud-service_"${VERSION}"_arm64/tmp/
cp -r conf activemq-for-cloud-service_"${VERSION}"_arm64/tmp
mkdir -p activemq-for-cloud-service_"${VERSION}"_arm64/DEBIAN
cp postinst prerm postrm activemq-for-cloud-service_"${VERSION}"_arm64/DEBIAN
mkdir -p activemq-for-cloud-service_"${VERSION}"_arm64/usr/share
tar -xf apache-activemq-6.0.0-bin.tar.gz -C activemq-for-cloud-service_"${VERSION}"_arm64/usr/share
# Take the config file out of the path and put in /tmp. Put it in place if there isn't already an (updated) copy in place
#  activemq.xml automatically has new cloud user and keystore credentials created for it on 1st installation
mv activemq-for-cloud-service_"${VERSION}"_arm64/usr/share/apache-activemq-6.0.0/conf/activemq.xml /tmp
# Remove the broker key and trust stores as the keystore will be recreated (on a new installation) or retained on installation
rm activemq-for-cloud-service_"${VERSION}"_arm64/usr/share/apache-activemq-6.0.0/conf/broker.ks activemq-for-cloud-service_"${VERSION}"_arm64/usr/share/apache-activemq-6.0.0/conf/broker.ts

mkdir -p activemq-for-cloud-service_"${VERSION}"_arm64/lib/systemd/system
cp activemq.service  activemq-for-cloud-service_"${VERSION}"_arm64/lib/systemd/system

cat << EOF > activemq-for-cloud-service_"${VERSION}"_arm64/DEBIAN/control
Package: activemq-for-cloud-service
Version: $VERSION
Architecture: arm64
Maintainer: Richard Austin <richard.david.austin@gmail.com>
Description: ActiveMQ messaging service which links security-cam NVRs to the Cloud Service
Depends: xmlstarlet,
         openjdk-17-jre-headless (>=17.0.0), openjdk-17-jre-headless (<< 17.9.9)
EOF

dpkg-deb --build --root-owner-group activemq-for-cloud-service_"${VERSION}"_arm64
