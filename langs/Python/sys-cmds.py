import os
import subprocess

subprocess.run(["ls", "-l"])
kernel = subprocess.check_output(["uname", "-a"]).decode().strip().lower()
print(kernel)
print(subprocess.Popen("echo Hello World", shell=True, stdout=subprocess.PIPE).stdout.read())


os.system("some_command < input_file | another_command > output_file")
print(os.popen("ls -l").read())
