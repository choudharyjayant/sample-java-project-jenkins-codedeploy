#!/bin/bash
cd /home/ubnutu/order/
nohup java -jar build/libs/*.jar  > /dev/null 2>&1 &
