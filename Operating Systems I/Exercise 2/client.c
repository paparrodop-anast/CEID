#include"header.h"
#include <unistd.h>
#include <fcntl.h>
#include <stdlib.h>
#include<stdio.h>
#include <sys/socket.h>
#include<string.h>
#include <stdlib.h> 
void random_tickets();
int sendTicket(tickets_t ticket);
int main(int argc,char *argv[]) 
{
    if(argc==1)
    {
        init_random();
        random_tickets();
    }
    else if(argc!=4)
    {
        printf("lathos arithmos orismaton\n");
        exit(1);
    }
    else
    {
        tickets_t ticket;
        ticket.num=atoi (argv[1]);
        if(ticket.num<1 || ticket.num >4)
        {
            printf("lathos arithmos eisitirion\n");
            exit(1);
        }
        
        char zone=argv[2][0];

        if( (zone!='A') && (zone!='B') && (zone!='C') && (zone!='D') )
        {
            printf("lathos orisma zonis\n");
            exit(1);
        }
        ticket.zone=zone;
        ticket.card=atoi (argv[3]);
        sendTicket(ticket);
        
    }
    return 0;
}

//returns 0 if the theatre is full 1 otherwise
int sendTicket(tickets_t ticket)
{
    int sd = socket(AF_UNIX, SOCK_STREAM, 0);
    struct sockaddr addr;        
    addr.sa_family = AF_UNIX;
    strcpy(addr.sa_data, SOCK_NAME);
    int len = sizeof(addr.sa_family) + sizeof(addr.sa_data);
    // connect to socket        
    connect(sd, &addr, len);
    
    if(sd<0)
    {
        perror("Unable to connect to the socket");
        exit(1);
    }
    
    if(write(sd,&ticket,sizeof(tickets_t)) < 0 )
    {
        perror("Unable to write to socket");
        exit(1);
    }
    
    int ret=0;
    char buff[100];
    do
    {
        if(my_read(sd,buff,100)<0 )
        {
             perror("Unable to read from the socket");
             exit(1);
        }
        printf("%s",buff);
        if(strcmp(buff,FULL_MSG)==0)
        {
            ret=1;
        }
        
    }while(strcmp(buff,FINISH) !=0);
        
    close(sd);
    return ret;
}

void random_tickets()    
{
    int flag=0;
    while(flag==0)
    {           
        tickets_t ticket;
        ticket.num=get_rand(3) +1;  
        int p=get_rand(9);    
        if(p==0)
        {
            ticket.zone='A';
        }
        else if(p<3)
        {
            ticket.zone='B';
        }
        else if(p<6)
        {
            ticket.zone='C';
        }
        else
        {
            ticket.zone='D';
        }
        
            
        //we get a random number avoiding 0
        ticket.card=get_rand(1000)+1;         
        
        flag=sendTicket(ticket);
    }
}