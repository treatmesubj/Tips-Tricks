# Debian 12 Bookworm doesn't support old Javas
# see ../Linux/Debian/apt/sources-list.md

sudo apt install openjdk-17-jdk openjdk-17-jre
sudo apt install openjdk-11-jdk openjdk-11-jre
# may have to sudo apt --fix-broken install

apt list --installed | grep openjdk

# understand current state
java -version
update-alternatives --query java
ls -l /etc/alternatives/java

sudo update-alternatives --config java  # switch from 17 to 11
java -version
