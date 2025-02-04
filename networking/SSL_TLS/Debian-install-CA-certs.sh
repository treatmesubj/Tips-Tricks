# download IBM CA certs
    # https://w3.ibm.com/w3publisher/certhub/ibm-internal-ca-application/root-intermediate
sudo mv IBM*der /usr/local/share/ca-certificates/
# rename certs to .crt
# per `man update-ca-certificates`...
    # "all certificates with a .crt extension"

sudo update-ca-certificates

# Updating certificates in /etc/ssl/certs...
# rehash: warning: skipping ca-certificates.crt,it does not contain exactly one certificate or CRL
# 2 added, 0 removed; done.
# Running hooks in /etc/ca-certificates/update.d...
# Processing triggers for ca-certificates-java (20230710~deb12u1) ...
# Adding debian:IBM-Intermediate-CA.pem
# Adding debian:IBM-Root-CA.pem
# done.
# done.
