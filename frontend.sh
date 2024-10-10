#!/bin/bash

source ./common.sh 

USER_VALID

echo "now you are in the Frontend module"

dnf install nginx -y &>>$LOG_FILE
VALIDATE $? "installing nginx"

systemctl enable nginx &>>$LOG_FILE
VALIDATE $? "enabling nginx"

systemctl start nginx &>>$LOG_FILE
VALIDATE $? "stsrting nginx"

rm -rf /user/share/nginx/html/* &>>$LOG_FILE
VALIDATE $? "removing the default content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip  &>>$LOG_FILE
VALIDATE $? "downlode the frontend code"

unzip /tmp/frontend.zip &>>$LOG_FILE
VALIDATE $? "unzip the frontend code"

cp /home/ec2-user/exp-11-shell/expense.conf /etc/nginx/default.d/expense.conf &>>$LOG_FILE
VALIDATE $? "coping the expense.conf file"

systemctl restart nginx &>>$LOG_FILE
VALIDATE $? "restarting the nginx"
