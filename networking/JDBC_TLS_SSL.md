## [About SSL/TLS Certificates](https://www.ssl.com/guide/pem-der-crt-and-cer-x-509-encodings-and-conversions/)
Connections to infrastructure & databases are made with Transport Layer Security (TLS) encryption/cryptographic protocol, the successor to Secure Sockets Layer (SSL), for secure communications utilizing trusted digital certificates signed by the [IBM Internal Certificate Authority (IBMCAPKI)](https://daymvs1.pok.ibm.com/ibmca/welcome.do) or sometimes, self-signed certificates from the servers that host databases, commonly in the PKCS12 PEM format.\
Administrators of servers/databases distribute their respective certificates to users/clients; users/clients simply utilize those certificates in their connection-configuration.\
Any databases that aren't using encryption are violating an ITSS standard; see [ITSS Use of Encryption](https://pages.github.ibm.com/ciso-psg/main/standards/itss.html#50-use-of-encryption) & [ITSS Acceptable Encryption Algorithms](https://pages.github.ibm.com/ciso-psg/main/supplemental/acceptable_encryption.html).\
How these certificates are utilized in connection configurations amongst different software clients varies.\
Some clients like [db2cli](https://www.ibm.com/docs/en/db2/11.5?topic=commands-db2cli-db2-interactive-cli) or [Python-ibmdb library](https://github.com/ibmdb/python-ibmdb) or [node-ibm-db library](https://github.com/ibmdb/node-ibm_db) utilize various formats of certificates.\
Commonly, an analyst will use a SQL client like [DBeaver](https://dbeaver.io/download/) or IBM's Query Management Facility (QMF) For Workstation on their computer. Both DBeaver & QMF applications utilize Java and the Java-specific Java TrustStore file containing the certificates of trustworthy servers.
1. If you don't already have the latest Type 4 DB2 JDBC driver, download it and utilize it in your tool: [JDBC 4.0 Driver for DB2/BigSQL](http://www-01.ibm.com/support/docview.wss?uid=swg21363866)
    - You'll probably want to download the `Data Server Driver for JDBC and SQLJ (JCC Driver)` package, which has a `.tar.gz` file extension. The driver resides in a `(.zip) compressed archive` in a `(.tar.gz) compressed archive`. Extract the driver; on most machines, you should be able to extract the driver from the from the archive with the below commands
        1. `cd <directory of downloaded file>`
        2. `tar -xvf v11.5.8_jdbc_sqlj.tar.gz`
        3. `cd jdbc_sqlj`
        4. `unzip db2_db2driver_for_jdbc_sqlj.zip`
            - You should see `db2jcc4.jar` in this directory
2. Ensure you have proper trusted IBM CA certificates for TLS
    - Download the very commonly used [IBM Internal CA Root Certificate](https://daymvs1.pok.ibm.com/ibmca-wireless/view/downloadCarootCert.do?file=carootcert.der)
    - Download the very commonly used [IBM Internal Intermediate CA Root Certificate](https://daymvs1.pok.ibm.com/ibmca/downloadCarootCert.do?file=caintermediatecert.der)
    - Each database has a unique CA Root SSL certificate, so you'll need to download their respective certificate.
3. Ensure you have a Java TrustStore containing your trusted IBM certificates for TLS over JDBC
    - To use the IBM CA certificates with Java-based tools (i.e., JDBC), a "TrustStore" must be created and utilized in the respective JDBC configuration. You can [install Java](https://www.java.com/en/download/help/download_options.html) and use its `keytool` command-line utility to create a Java TrustStore file containing the IBM certificates with the following commands (assuming you add the directory of the Java `keytool` command-line utility to your machine's PATH)
        - `keytool -importcert -alias <my-preferred-alias-for-cert> -trustcacerts -file <my-cert-file.cert> -keystore ibm-truststore.jks`
        - `keytool -v -list -keystore ibm-truststore.jks`
4. Configure a TLS/SSL secured JDBC connection, utilizing your Java TrustStore, to a database.
    - Depending on which tool you're using to establish your JDBC connection, (i.e., DBeaver, QMF), you may need to configure the driver parameters such as `sslConnection=true;sslTrustStoreLocation=<path-to-ibm-truststore.jks-here>;sslTrustStorePassword=<password-here>;` in separate fields other than the JDBC URL, so refer to your tool's documentation.
    - Also, consider the additional High-Availability (HA) load-balancing proxy driver parameters for further troubleshooting
        ```
        enableClientAffinitiesList=1;
        enableSeamlessFailover=true;
        clientRerouteAlternatePortNumber=443;
        clientRerouteAlternateServerName=(use hostname earlier in table);
        ```

---
#### Export certificates from a TrustStore
- try this to see the certificates in your truststore and take note of each one's alias
    - `keytool -v -list -keystore ibm-truststore.jks`
- then try this to export a certificate from the truststore to a `PKCS12` format cert (alias `ibmcaintermediate` in my example)
    - `keytool -importkeystore -srckeystore ibm-truststore.jks -destkeystore ibmcaintermediate.p12 -deststoretype PKCS12 -srcalias ibmcaintermediate`
- then try this to convert the cert from PKCS12 format to PEM format
    - `openssl pkcs12 -in ibmcaintermediate.p12  -nokeys -out cert.pem`
---

### JARs - Drivers & Classes
```
db2jcc4.jar                     -- newer DB2 driver & class
db2jcc.jar                      -- older DB2 driver & class
db2jcc_license_cisuz.jar        -- DB2 z/OS license
db2jcc_license_cu.jar           -- DB2 z/OS license
```

---

### [JDBC & SQLJ Driver Properties](https://www.ibm.com/docs/en/db2/12.1?topic=information-data-server-driver-jdbc-sqlj-configuration-properties)

### Troubleshooting Errors
#### JDBC Driver Issues
Common error below signifies a JDBC driver issue; [docs](https://www.ibm.com/docs/en/db2-for-zos/13?topic=jsri-error-codes-issued-by-data-server-driver-jdbc-sqlj)
1. Your driver is likely outdated and no longer compatible with database you're trying to connect to; see above docs on how to use latest driver.
2. You may need to use the High-Availability (HA) driver parameters; see above.
```
Execution failed due to a distribution protocol error that caused deallocation of the conversation.
A DRDA Data Stream Syntax Error was detected.  Reason: 0x3. ERRORCODE=-4499, SQLSTATE=58009
```
#### TLS/SSL Issues
Common error below signifies a TLS/SSL certificate/truststore issue.\
Ensure your tool's connection configuration is using necessary certificates.
```
ERRORCODE=-4499, SQLSTATE=08001
```
- You may check that your TrustStore contains all required certificates to successfully connect to host: `openssl s_client -verify 100 -showcerts -connect <host>:<port> -servername <host> -CAfile  <(keytool -list -rfc -keystore <ibm-truststore.jks> -storepass <TrustStore-password>)`
    - If in the output, you see `verify error:num=19:self signed certificate in certificate chain`, one of the certificates in the certificate-chain sent from the server was signed by itself, and that certificate was not in your TrustStore.
- You may check a certificate directly: `openssl s_client -showcerts -connect <host>:<port> -servername <host> -CAfile <file.cert>`
    - If in the output, you see `verify error:num=7:certificate signature failure`, one of the certificates in certificate-chain sent from the server was not signed by your trusted certificate.
    - If you get an error like below, try `ping`ing the server to see if you can reach it, then try `nmap`-ing the Db2's expected port on the server to see if it's open
        ```
        $ openssl s_client -showcerts -connect <host>:<port> -servername <host> -CAfile <file.cert>
        4067DA19007F0000:error:8000006F:system library:BIO_connect:Connection refused:../crypto/bio/bio_sock2.c:114:calling connect()
        4067DA19007F0000:error:10000067:BIO routines:BIO_connect:connect error:../crypto/bio/bio_sock2.c:116:
        connect:errno=111
        $ nmap -p 5520-5521 <host>
        PORT     STATE  SERVICE
        5520/tcp closed sdlog
        5521/tcp closed unknown
        ```

#### [DB2 Authentication Methods Docs](https://www.ibm.com/docs/en/cloud-paks/cp-data/4.6.x?topic=credentials-user-supported-authentication-methods)

