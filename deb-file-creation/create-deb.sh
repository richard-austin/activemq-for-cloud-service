#!/bin/bash

export VERSION
VERSION=$(< version.txt)

rm -r activemq-for-cloud-service_*_arm64
mkdir -p activemq-for-cloud-service_"${VERSION}"_arm64/tmp/
cp -r conf activemq-for-cloud-service_"${VERSION}"_arm64/tmp
cp apache-activemq-6.0.0-bin.tar.gz activemq-for-cloud-service_"${VERSION}"_arm64/tmp
mkdir -p activemq-for-cloud-service_"${VERSION}"_arm64/DEBIAN
cp postinst prerm activemq-for-cloud-service_"${VERSION}"_arm64/DEBIAN

mkdir -p activemq-for-cloud-service_"${VERSION}"_arm64/lib/systemd/system
cp activemq.service  activemq-for-cloud-service_"${VERSION}"_arm64/lib/systemd/system

cat << EOF > activemq-for-cloud-service_"${VERSION}"_arm64/DEBIAN/control
Package: activemq-for-cloud-service
Version: $VERSION
Architecture: arm64
Maintainer: Richard Austin <richard.david.austin@gmail.com>
Description: ActiveMQ messaging service which links security-cam NVRs to the Cloud Service
Depends: openjdk-19-jre-headless (>=19.0.2), openjdk-19-jre-headless (<< 19.9.9)
EOF

dpkg-deb --build --root-owner-group activemq-for-cloud-service_"${VERSION}"_arm64
