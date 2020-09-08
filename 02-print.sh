#!/bin/bash

echo Hello

## Print Multi line with \n and tab spaces with \t
echo -e "Welcome to DevOps Training\n\tTopic is Shell Scripting"

## Some programming languages multiple lines are done with \3n, But in echo in shell we dont have that , We have to use \n\n\n

# Some times to grab the attention of user we need to print text in bold, underline and even some colors. with \e option

# syntax for enabling this is: echo -e "\e[COL-CODEmMESSAGE\e[0m"
# echo - print message
# -e to enable colors with \e
# \e - enable color
# [COL-CODE - some color code
# m - End of color code
# MESSAGE - Message to print
# \e - enable one more color
# [0m - Zero is going to disable the color.

# https://misc.flogisoft.com/bash/tip_colors_and_formatting

## Color Codes
# 1 - bold
# 4 - underlined
# 31,41 - red
# 32,42 - green
# 33,43 - yellow
# 34,44 - blue
# 35,45 - magenta
# 36,46 - cyan

echo -e "\e[1mHello World in Bold text\e[0m"
echo -e "\e[4mHello World in Underlined text\e[0m"

echo -e "\e[31mHello World in Red Color\e[0m"
echo -e "Yellow Color, But only \e[33mYellow\e[0m word is Yellow color "

echo -e "\e[42mGreen Background\e[0m"

## Combinations

echo -e "\e[1;33mBold Yellow\e[0m"
echo -e "\e[31;43;4mRed On Yellow with underlined\e[0m"
