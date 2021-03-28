#!/bin/bash
#
# This script is for the bash lab on variables, dynamic data, and user input
# Download the script, do the tasks described in the comments
# Test your script, run it on the production server, screenshot that
# Send your script to your github repo, and submit the URL with screenshot on Blackboard

# Get the current hostname using the hostname command and save it in a variable
HOST=$(hostname)
# Tell the user what the current hostname is in a human friendly way
clear
echo "****"
echo The current host name is: $HOST
echo "****"
echo ""
# Ask for the user's student number using the read command
echo -n "Please type your student number > ";read STUDENT
# Use that to save the desired hostname of pcNNNNNNNNNN in a variable, where NNNNNNNNN is the student number entered by the user
newname="pc$STUDENT"
echo ""
# If that hostname is not already in the /etc/hosts file, change the old hostname in that file to the new name using sed or something similar and
#     tell the user you did that
grep -q $newname /etc/hosts &&
      echo The host name is already with your student number ||
      (echo I have to change the host name from $HOST to your student number $newname, wait to enter sudo password &&
      hostnamectl set-hostname $newname &&
      sudo sed -i "s/$HOST/$newname/" /etc/hosts)
echo ""
#e.g. sed -i "s/$oldname/$newname/" /etc/hosts
# If that hostname is not the current hostname, change it using the hostnamectl command and
#     tell the user you changed the current hostname and they should reboot to make sure the new name takes full effect

if [ ! $HOST == $newname ];
then
    echo -n "To make changes effective we need to reboot the system, press enter to continue.... > ";read EMPTYKEY
    sudo reboot
fi
