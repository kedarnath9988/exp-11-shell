#!/bin/bash 


source ./common.sh 

USER_VALID


echo "please enter the mysql password"
read PASSWORD_MYSQL   

dnf install mysql-server -y &>>$LOG_FILE
VALIDATE $? "installing mysqql-server"

systemctl enable mysqld &>>$LOG_FILE
VALIDATE $? " enabling mysql "

systemctl start mysqld &>>$LOG_FILE
VALIDATE $? "start mysqld "

mysql -h db.dawskedarnath.online -uroot -p${PASSWORD_MYSQL} -e 'show databases;' &>>$LOG_FILE
if [ $? -eq 0 ]
then 
    echo  -e "$G  password already setuped successfully $N"
else 
    mysql -h db.dawskedarnath.online --set-root-pass ${PASSWORD_MYSQL}  &>>$LOG_FILE
    VALIDATE $? "setting mysql passwd "
fi 
