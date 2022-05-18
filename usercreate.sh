#!/bin/bash


#this script is for creating users
#

if [[ ${UID} -ne 0 ]]
then
echo "you have to be root to execute"
exit 1
fi



if [[ ${#} -lt 1 ]]
then
echo "Please enter atleast one parameter"

echo "Usage:   sudo sh usercreate [name]"
echo "with root: sudo sh usercreate [name] root"
exit 1
fi


username=$1





useradd ${username}

if [[ ${?} -ne 0 ]]
then
echo "user could not be created successfully"
exit 1
fi


echo "creating user ${username} .... "
sleep 2


password=$(date +%s | sha256sum | head -c8)

echo "setting up password for user ......"
sleep 3
echo ${password} | passwd --stdin ${username}

if [[ ${?} -ne 0 ]]
then
echo "could not create password for user ${username}"
exit 1
fi


passwd -e ${username}

if [[ $2 == "root" && ${#} -eq 2 ]]
then
echo "setting up ${username} as a sudo user........."
sleep 3
echo "${username}    ALL=(ALL)       ALL" | sudo EDITOR='tee -a' visudo

if [[ ${?} -eq 0 ]]
then
echo "user ${username} is now a super user"
else
echo "could not create the user as root"
fi

fi




echo "Hurray!!! ${username} your password is ${password}"
