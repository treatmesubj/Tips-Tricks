openssl s_client -connect <host>:<port> -showcerts # -servername <host> -CAfile <file.cert>
openssl s_client -connect <host>:<port> -showcerts # -servername <host> -CAfile <(keytool -list -rfc -keystore <ibm-truststore.jks> -storepass <TrustStore-password>)
