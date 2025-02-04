# https://stackoverflow.com/questions/66848351/why-python-requests-not-use-the-system-ssl-cert-by-default
export REQUESTS_CA_BUNDLE="/etc/ssl/certs/ca-certificates.crt"  # system installed CA certs

script="
import ssl
import requests
print(ssl.get_default_verify_paths())
x = requests.get(\"https://google.com\")
print(x)
"
python -c "$script"
