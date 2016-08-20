# set the compiler
CC=gcc
# options I'll pass to the compiler.
CFLAGS= -Wall

all: server client utils
	
server: server_thr.c utils 
	$(CC) $(CFLAGS) -lpthread server_thr.c utils.o  -o $@

client: client.c header.h utils
	$(CC) $(CFLAGS) client.c utils.o -o $@
	
utils: utils.c
	$(CC) $(CFLAGS) -c utils.c -o $@.o

clean:
	rm -rf server client utils.o thr_list.o