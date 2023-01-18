# I need to run a Python script which uses the input function, properly still see the input prompt in the shell, and save stdout to a file
python3 -c "input('what?: '); print('\nokay, great'); print('bye then');" | tee ~/output.txt

<<comment
$ python3 -c "input('what?: '); print('\nokay, great'); print('bye then');" | tee ~/output.txt
what?: nothin

okay, great
bye then
$ cat ~/output.txt
what?:
okay, great
bye then
$
comment