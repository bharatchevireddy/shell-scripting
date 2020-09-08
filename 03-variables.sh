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

# Some times you may need to store multiple values in a single variable.
# In shell we call it as array, In some scripting languages this is called as a list.

ARRAY=(1,2,abc,20,0.0.1)

# Single Array can hold multiple daata types, Ofcourse in shell everything is a string.

# How to access a particular value

echo INDEX0 = ${ARRAY[0]}
