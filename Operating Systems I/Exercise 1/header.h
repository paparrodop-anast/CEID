#ifndef TICKETS_H
#define TICKETS_H

#define ZONE_A 1
#define ZONE_B 2
#define ZONE_C 3
#define ZONE_D 4

#define SOCK_NAME "THEATRO"
#define FINISH "antio\n"
#define FULL_MSG "to theatro einai gemato\n"

typedef struct tickets_t
{
    short int num;
    char zone;
    int card;
} tickets_t;



/* returns a random number between 0  and max*/
int get_rand(int max);
/* initialize random seed: */
void init_random();

void my_sleep(int sec);

int my_write(int ns,char *s);
int my_read(int ns,char *s,int size);
#endif