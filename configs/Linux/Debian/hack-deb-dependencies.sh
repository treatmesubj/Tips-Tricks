# https://serverfault.com/a/859394
apt-get download yourpackage
mkdir PackageFolder
dpkg-deb -x yourpackage.deb PackageFolder
dpkg-deb --control yourpackage.deb PackageFolder/DEBIAN  # rename-dependency
vim PackageFolder/DEBIAN/control
dpkg -b PackageFolder yourpackage2.deb
apt-get install ./yourpackage2.deb
