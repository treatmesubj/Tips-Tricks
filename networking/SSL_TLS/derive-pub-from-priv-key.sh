# https://stackoverflow.com/a/1373088
openssl rsa -in private.pem -pubout -out public.pem

# https://security.stackexchange.com/questions/9957/can-i-use-a-private-key-as-a-public-key-and-vice-versa/9964#9964
# encrypt with pub or priv key?

# 1. if you wanted to put encrypted data out in the world in a Cloudant doc that
# only you could decrypt with your unshared private key, you'd do it that way;
# encrypt with public, decrypt with private

# 2. if you want to prove data came from you, you'd encrypt with private, since
# only you could encrypt that way
