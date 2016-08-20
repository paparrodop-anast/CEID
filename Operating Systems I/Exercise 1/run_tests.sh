#!/bin/bash

#clean up 
killall server 2>/dev/null
killall client 2>/dev/null


./server &

# na prolabi na anoi3ei to socket
sleep 1

for i in `seq 1 15`;
do
    ./client &
done
