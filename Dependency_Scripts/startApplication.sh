#!/bin/bash
mkdir /home/ubuntu/order_service
cp -r /home/ubuntu/order /home/ubuntu/order_service
cd /home/ubuntu/order_service/target/
nohup java -jar jb-hello-world-maven-0.2.0.jar  > /dev/null 2>&1 &
