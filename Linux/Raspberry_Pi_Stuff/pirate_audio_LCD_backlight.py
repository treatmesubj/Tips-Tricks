# https://pinout.xyz/pinout/pirate_audio_line_out#
# $ pinout
# need to lower PWM to GPIO 13 (33)

import RPi.GPIO as GPIO


GPIO.setmode(GPIO.BCM)
# we'll have GPIO package deal with BCM (Broadcom GPIO 00..nn numbers)
# rather than BOARD (Raspberry Pi board numbers)
GPIO.setup(13, GPIO.OUT)  # set BCM pin 13 to output a signal
backlight_pin = GPIO.PWM(13, 500)  # set BMC pin 13 to pulse signal waves high(on)/low(off) modulated at 500Hz frequency (500 times a second)
backlight_pin.start(100)  # for each pulse cycle, the signal should be high (on duty) for 100% of the cycle; duty-cycle = 100%
backlight_pin.ChangeDutyCycle(50)  # for each pulse cycle, the signal should be high for 50% of the cycle; duty-cycle = 50%

backlight_pin.stop()