1. `curl http://abyz.me.uk/rpi/pigpio/code/gpiotest.zip -O`
2. `unzip gpiotest.zip`
3. do below

```
wget https://github.com/joan2937/pigpio/archive/master.zip
unzip master.zip
cd pigpio-master
make
sudo make install
```

```
john@raspberrypi:~ $ ./gpiotest
This program checks the Pi's (user) gpios.

The program reads and writes all the gpios.  Make sure NOTHING
is connected to the gpios during this test.

The program uses the pigpio daemon which must be running.

To start the daemon use the command sudo pigpiod.

Press the ENTER key to continue or ctrl-C to abort...

Testing...
Skipped non-user gpios: 0 1 28 29 30 31
Tested user gpios: 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27
Failed user gpios: None
```
