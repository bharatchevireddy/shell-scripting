#!/bin/bash

# 1. While executing

read -p 'Enter your Name: ' name

echo "Hello $name, Welcome to DevOps Training"

## Problem with while exuting is , It will not proceed until you provide the input. So when we run this with automation we will end up with errors in this approach.
# So all the inputs providing before execution is good for automation

# 2. Before executing

## Some Variables can help you in talking the input which are provided as arguments before executing.
# Variables for this are $0-$n , $* , $@ , $#

echo Script Name = $0
echo First Argument = $1
echo Second Argument = $2
echo All Arguments = $*
echo All Arguments = $@
echo Number of Arguments = $#