import subprocess


pod_name = str(subprocess.check_output(['uname', '-a']))
assert os.environ.get('MY_ENVVAR') is not None, f"{pod_name}: not finding the Box Private Key"
