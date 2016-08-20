# set the compiler
CC=gcc
# options I'll pass to the compiler.
CFLAGS= -Wall 

all: server client utils
	
server: server.c header.h utils
	$(CC) $(CFLAGS) -lpthread server.c utils.o -o $@

client: client.c header.h utils
	$(CC) $(CFLAGS) client.c utils.o -o $@
	
utils: utils.c
	$(CC) $(CFLAGS) -c utils.c -o $@.o


clean:
	rm -rf server client utils.o