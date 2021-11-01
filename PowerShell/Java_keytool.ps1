# add certificate to keystore
keytool -importcert -alias <cert_alias> -trustcerts -file <cert_file> -keystore <keystore_file>

# list certs in keystore
keytool -v -list -keystore <keystore_file>