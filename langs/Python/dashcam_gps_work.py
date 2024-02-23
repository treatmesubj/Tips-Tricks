import os
import sys
import re
import subprocess


"""
iterates files in a given directory of Thinkware dashcam MP4 files,
parses their raw data for GPS metadata using GNU strings utility,
and appends their GPS metadata to a text file
"""

# reggy = re.compile(r"[A-Z]{2}RMC,(\d{2})(\d{2})(\d+(\.\d*)?),A?,(\d*?)(\d{1,2}\.\d+),([NS]),(\d*?)(\d{1,2}\.\d+),([EW]),(\d*\.?\d*),(\d*\.?\d*),(\d{2})(\d{2})(\d+)")
# results = reggy.findall(line)
# mph = float(results[0][10]) * 1.15078
# date = f"{results[0][13]}/{results[0][12]}/{results[0][14]}"

for file_name in os.listdir(sys.argv[1]):
    if not file_name.endswith(".MP4"):
        continue
    print(file_name)
    p = subprocess.run(["strings", f"{sys.argv[1]}/{file_name}"], capture_output=True, text=True)
    p2 = subprocess.run(["grep", "-e" "GPRMC", "-e", "GPVTG", "-e", "GPGSA", "-e", "GPGSV", "-e", "GPGLL"], input=p.stdout, capture_output=True, text=True)
    mp4_gps_metadata = p2.stdout

    with open('mp4_gps_metadata.gps', 'a') as gps_outfile:
        for line in mp4_gps_metadata.splitlines():
            gps = line.split(';')[1]
            print(gps)
            gps_outfile.write(f"{gps}\n")
