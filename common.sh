#!/bin/bash 

USER=$(id -u )
TIME=$( date +%F-%H-%M-%S )
SCRIPT=$( echo $0 | cut -d "." -f1 )
LOG_FILE=/tmp/$SCRIPT-$TIME.log

# colours 

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

VALIDATE(){
    if [ $1 -eq 0 ]
    then 
        echo -e "$G $2 done successfully .. $N"
    else 
        echo -e "$R $2 failure .. $N"
        exit 1 
    fi 
}

echo "script is " $0 

USER_VALID(){
    if [ $USER -eq 0 ]
    then
        echo -e "$G you are super-user $N"
    else 
        echo -e "$R need super user access $N"
        exit 1 
    fi 
}