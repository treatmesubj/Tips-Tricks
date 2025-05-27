# https://docs.python.org/3/library/inspect.html


# Return the name of the (text or binary) file in which an object was defined.
# This will fail with a TypeError if the object is a built-in module, class , or
# function.
import inspect
from source.helpers.token_generator import TokenGenerator
inspect.getfile(TokenGenerator)
# '/Raptors/source/helpers/token_generator.py'

import sys
print(sys.path)
# ['/Raptors', ... ]

import os
print(os.environ['PYTHONPATH'])
# ['/Raptors', ... ]
