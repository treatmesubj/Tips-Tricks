import keyring
import keyring.util.platform_ as keyring_platform
import getpass

service_name = "github.ibm.com"
keyring.set_password(service_name=service_name, username=input("username: "), password=getpass.getpass())

