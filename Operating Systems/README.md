#### Operating Systems 

This repository contains the two assignments of the course Operating Systems and were executed in collaboration with Charalabos Logdanidis.

###### Assignment #1: 

In this assignment we had to create a system in which the phone operators were responsible for the booking of the seats in a theatre. A process of the server must find the available seats, charge the clients and book the seat, while the clients are connected to the server through a client-process.
Some tools that were used are `fork`, `shared memory`, `sockets`, `semaphores` and `signals`. 

###### Assignment #2:

In this second assignment we had the same system as before but with some adjustments. Now the server makes the booking by charging the client's credit card and with every new client a new thread is created so that he/she is accommodated. Because the operators of the theatre are only 10, if a point comes that more than 10 clients are connected, some threads are stuck in a condition until there is an operator that is available again. As a similar challenge, the bank employees are only 4, so if there are more than 4 charging requests they are stuck in another condition accordingly.