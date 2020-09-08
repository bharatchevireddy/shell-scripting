#!/bin/bash

# syntax: VARNAME=DATA
a=10    # Number
b=xyz   # Characters
c=true  # Boolean
d=0.0.1 # Float

# Yet you have different data types , Shell will consider everything as string, String is nothing but the combinations of any of the above
# Mainly string is combination of numbers and characters

## How to access that
# $VARNAME or ${VARNAME}


echo $a
