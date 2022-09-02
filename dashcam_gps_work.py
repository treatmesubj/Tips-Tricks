import os
import re
import subprocess


reggy = re.compile(r"[A-Z]{2}RMC,(\d{2})(\d{2})(\d+(\.\d*)?),A?,(\d*?)(\d{1,2}\.\d+),([NS]),(\d*?)(\d{1,2}\.\d+),([EW]),(\d*\.?\d*),(\d*\.?\d*),(\d{2})(\d{2})(\d+)")

for file in os.listdir():
    print(file)
    p = subprocess.run(["strings", file], capture_output=True, text=True)
    p2 = subprocess.run(["grep", "-e" "GPRMC", "-e", "GPVTG", "-e", "GPGSA", "-e", "GPGSV", "-e", "GPGLL"], input=p.stdout, capture_output=True, text=True)
    mp4_gps_metadata = p2.stdout

    with open('mp4_gps_metadata.gps', 'a') as filey:
        filey.writelines(mp4_gps_metadata)
        # results = reggy.findall(line)
        # mph = float(results[0][10]) * 1.15078
        # date = f"{results[0][13]}/{results[0][12]}/{results[0][14]}"
