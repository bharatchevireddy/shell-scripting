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

ARRAY=(1 2 abc 20 0.0.1)

# Single Array can hold multiple data types, Ofcourse in shell everything is a string.

# How to access a particular value

echo INDEX0 = ${ARRAY[0]}

# Since we are accessing arrays with INDEX, In shell we call this as Index Arrays.

# Alternate to that your array can be accessed with NAME as well, that becomes Named Arrays & in other scripting languages we call it as MAP

declare -A MYMAP=( [course]=DevOps [time]=0730 [zone]=IST )

echo "Welcome to ${MYMAP[course]} Training, Timing is ${MYMAP[time]} ${MYMAP[zone]}"

# Variables names can contain, NUMBERS, CHARACTERS & _ (Underscore). You cannot use special character like *,?: and so on
# Also variable cannot start with a number, 1a is wrong, a1 is right variable

# Most of the times we need the data while running the script.
# We can execute a command and that command output can be stored in a variable.

DATE=$(date +%F) # Command substitution  $()
echo -e "Welcome to DevOps Training, Today date is $DATE"

# One more dynamic variables can be done by using Arithmetic expressions

VALUE=$((20+203-4*2/6)) # # Arithmetic substitution  $(())

echo VALUE = $VALUE