# activemq-for-cloud-service
### ActiveMQ messaging service installer for linking the security-cam CCTV NVR and cloud service

*This is required when you want to access 1 or more security-cam NVRs
through the ActiveMQ version of the Cloud Server. It is not required for
direct access to the NVR*

### Overview
* Creates an installer (deb file) for ActiveMQ configured for ssl and
authenticated access.
* SSL certificate and relevant ActiveMQ config files in deb-file-creation/conf.
  * if you want to update the broker certificate, see the ActiveMQ <a href="https://activemq.apache.org/how-do-i-use-ssl">documentation</a>.
  Note that the client truststores (client.ts) on both the security-cam NVRs and the Cloud server will have to be updated to include the new broker_cert..
  * To change the authentication credentials for ActiveMQ, see <a href="https://medium.com/@ankithahjpgowda/enable-authentication-and-configure-activemq-in-java-application-5c3d1c185a67#:~:text=To%20enable%20authentication%2C%20you%20can,with%20required%20username%20and%20password.&text=We%20can%20use%20any%20of,to%20ActiveMQ%20from%20our%20application">this</a> document.
  The application.]yml files on both the NVRs and on the Cloud Service will need the mqUser and mqPassword parameters changes
  accordingly to bew able to authenticate on ActiveMQ.

* ActiveMQ can be run on the same device as the Cloud server or separately. In either case, you must ensure that
mqURL on the Cloud server and all relevant NVRs are set to include the correct hostname or IP address.

### Build the installer
* from the project home directory (activemq-for-cloud-service), run ./gradlew buildDebFile. The deb file will be created at
the sub directory deb-file-creation. As supplied, this is set for installation on an arm84 Ubuntu 23.10 platform. 

