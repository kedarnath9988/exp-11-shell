#!/bin/bash

source ./common.sh

USER_VALID

dnf module disable nodejs:18 -y &>> $LOG_FILE
VALIDATE $? "disable nodejs"

dnf module enable nodejs:20 -y &>> $LOG_FILE
VALIDATE $? "enable nodejs"

dnf install nodejs -y &>> $LOG_FILE 
VALIDATE $? "install nodejs"

id expense &>> $LOG_FILE
if [ $? -eq 0 ]
then
    echo -e "$G User already existed $N"
else
    useradd expense &>> $LOG_FILE
    VALIDATE $? "creating expense user"
fi 

mkdir -p /app
VALIDATE $? "/app creating "

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOG_FILE
VALIDATE $? "downlode the backend code"

cd /app
rm -rf /app/* &>>$LOG_FILE
unzip /tmp/backend.zip  &>>$LOG_FILE
VALIDATE $? "unzip the code "

cd /app &>>$LOG_FILE
VALIDATE $? "moving to /app"

cp /home/ec2-user/exp-11-shell/backend.service /etc/systemd/system/backend.service &>>$LOG_FILE
VALIDATE $? "copying the service file" 

systemctl daemon-reload backend &>>$LOG_FILE
VALIDATE $? "daemon-reload "

systemctl enable backend &>>$LOG_FILE
VALIDATE $? "enabling backend"

systemctl start backend &>>$LOG_FILE
VALIDATE $? "sterting backend "

dnf install mysql -y &>>$LOG_FILE
VALIDATE $? "install mysql clint"


mysql -h db.dawskedarnath.online -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$LOG_FILE
VALIDATE $? "loading scheming"

systemctl restart backend &>>$LOG_FILE
VALIDATE $? "resatrting backend "