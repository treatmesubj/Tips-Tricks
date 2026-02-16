# nested quotes contents
cat blah.log
# jfdklajfksla "jfdkslajfkls"target"jfdksljakl" jfdkasljfaksljkl
#
rg -io '"[^"]*tar[^"]*"' blah.log
# 4:"target"

# multi-line nested quotes
cat blah.log
# jfdklajfksla "jfdksla
#
# jfkls"ho
# hey
# target"jfdksljakl" jfdkasljfaksljkl
#
rg -ioU --multiline-dotall '"[^"]*tar[^"]*"' blah.log
# 3:"ho
# 4:hey
# 5:target"

# grep for any SCHEMA.TABLE
rg -i '\w+\.\w+\s'
# grep for any MY_SCHEMA*.TABLE
rg -i 'MY_SCHEMA\w*\.\w+\s'

#   Show all lines that do not contain the # character.
grep -v -E "#" /etc/ssh/sshd_config
#   Search for all lines that contain a word that starts with Permit.
grep -E "[.]*\sPermit" /etc/ssh/sshd_config
#   Search for all lines that contain a word ending with Authentication.
grep -E "Authentication\b" /etc/ssh/sshd_config
#   Search for all lines containing the word Key.
grep -E "key" /etc/ssh/sshd_config
#   Search for all lines beginning with Password and containing yes.
grep -E "^Password.*yes$" /etc/ssh/sshd_config
