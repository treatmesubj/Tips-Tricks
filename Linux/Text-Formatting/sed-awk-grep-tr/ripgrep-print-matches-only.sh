# ripgrep, rg, print matches only, clean
rg -iIN "match"
# jfkdal match
#       fdaj            match
# match fjdkal
#       match  fdasjk
# match fdasj
# match
#     fdjaskl      match

rg -ioIN "match"
# match
#                   match
# match
#       match
# match
# match
#           match
