#include"header.h"
#include <time.h>  
#include <stdlib.h>     /* srand, rand */
#include <unistd.h>
#include  <fcntl.h>
#include<string.h>

#define BUFF_S 100
int get_rand(int max)
{
     //return  rand() / (RAND_MAX + 1.0) * (max + 1 - min) + min ;
          
     float ratio = (float) ( rand() ) / ( (float)RAND_MAX + 1);
     return   ratio * (max+1) ;
}

void init_random()
{
     /* initialize random seed using the current time*/
  srand (getpid());
}

void my_sleep(int sec)
{
    do
    {
        sec=sleep(sec);
    }while(sec>0);
}

int my_write(int ns,char *s)
{
    char buff[BUFF_S];
    memset(buff,'\0',BUFF_S);
    strncpy(buff,s,BUFF_S-1);
    return write(ns,buff,BUFF_S);
}

int my_read(int ns,char *s,int size)
{
    char buff[BUFF_S];
    memset(buff,'\0',BUFF_S);    
    int ret = read(ns,buff,BUFF_S);
    if(ret<0)
    {
        return ret;
    }
    strncpy(s,buff,ret);
    return ret;
}