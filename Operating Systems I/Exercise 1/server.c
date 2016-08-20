#include"header.h"

#include <stdio.h>
#include <unistd.h>
#include <stdlib.h> /*standard library definitions*/
#include <string.h> /*string operations*/
#include <sys/types.h> /* basic system data types */
#include <sys/socket.h> /* basic socket definitions */
#include <errno.h> /* for the EINTR constant */
#include <sys/wait.h> /* for the waitpid() system call */
#include <sys/un.h> /* for Unix domain sockets */
#include <signal.h> /*signal name macros, and the signal*/
#include <sys/ipc.h> /* for shared memory */
#include <sys/shm.h> /* for shared memory */
#include <semaphore.h>/*defines the sem_t type ,used in performing semaphore operations*/
#include <fcntl.h> /*file control options*/
#include <sys/stat.h> /*defines the structure of the data returned by the function stat()*/ 


#include <semaphore.h>
#include <sys/stat.h>
#include <fcntl.h>

#define N_COMPANY 10
#define T_SEATFIND 6
#define N_BANK 4
#define T_CARDCHECK 2
#define T_WAIT 10
#define T_TRANSFER 30

#define A_NUM 100
#define B_NUM 130
#define C_NUM 180
#define D_NUM 230

#define SUCCESS "H kratisi oloklirothike epitixos.\n"
#define ID_MSG "To anagnoristiko tis einai %d.\n"
#define MONEY_MSG "To sinoliko kostos tis kratisis sas einai %d.\n"

#define NO_SEATS "den iparxoun diathesimes thesis stin sigekrimeni zoni\n"
#define CARD_FAILD "h pistotiki sas karta den egine apodexth\n"
#define WAIT_MSG "signomi gia tin kathisterisi\n"

#include <time.h>


#define SHM_KEY  123555 /*shared memory key*/

typedef struct thesis_t
{
    int A[A_NUM];
    int B[B_NUM];
    int C[C_NUM];
    int D[D_NUM];
} thesis_t;

typedef struct statistics
{
    int fail;
    int succeded;
    time_t wait_time;
    time_t e3ipiretisi_time;
    int transfer[100];
} statistics;

int *company_account; //trapezikos logariasmou tilefonikis eterias
int *theater_account; //trapezikos logariasmou theatrou
thesis_t *plano;  //to sinolo ton theseon
int *full; //positive if the theater is full
statistics *statist;

int sd;     //descriptor gia to socket
int shm_id; //id for share memory


sem_t *sem_tilef; //semephor gia tous tilefonites
sem_t *sem_bank;  //semaphore gia ton elenxo tis kartas
sem_t *sem_data;  //semephor gia prosbasi stin mnimi

void init_share_mem();
void child_proces_tilefonitis(int ns);
void print_stat();

int thesis_num;//o sinolikos arithmos ton theseon
//poiter to share memory
void *data;

int pid_bank;

void sig_chld() /*The use of this functions avoids the generation of "zombie" processes.*/
{         
    while ( waitpid(-1, NULL, WNOHANG) >0) ; /*wait for a child process to stop or terminate*/
}

void safe_exit() /*exit at iterapt and terminate signal */
{ 
    print_stat();
    
    sem_destroy(sem_bank);
    sem_destroy(sem_tilef);
    sem_destroy(sem_data);
    shmdt(data);
    close(sd);
    unlink(SOCK_NAME);
    exit(0);        
}

void safe_exit_child()   /*exit at iterapt and terminate signal for children processes*/
{    
    shmdt(data);
    exit(0);        
} 

void child_finish(int ns, int succeded,time_t wait_time,time_t timer)
{
    my_write(ns,FINISH);
    close(ns);
    time_t e3ipiretisi_time = time(NULL) - timer;
    sem_wait(sem_data);
    
    if(succeded>0)
    {
        statist->succeded++; 
        succeded=statist->succeded;
    }
    else
    {
        statist->fail++;
    }
    
    statist->wait_time+=wait_time;
    statist->e3ipiretisi_time+=e3ipiretisi_time;
    sem_post(sem_data);
}

void transfer_money()
{
    signal( SIGINT, safe_exit_child ); /*signal for termination of the process */
    signal( SIGTERM, safe_exit_child ); /*signal for termination of the process */
    init_share_mem();
    int i=0;
    while(1)
    {        
        my_sleep(T_TRANSFER);

        sem_wait(sem_data);//critical data section
        
        if(*company_account>0)
        {
            (*theater_account) += *company_account;
            statist->transfer[i]=*company_account;
            *company_account=0;
            i++;
        }        
        sem_post(sem_data);//critical data section
        
    }
}

void print_stat()
{
    
    sem_wait(sem_data);    
    
    int money=*theater_account + *company_account;
    
    
    int i;
    float all=statist->fail+statist->succeded;
    printf("pososto apotixias: %f\n",(float)statist->fail/all);
    printf("mesos xronos anamonis: %f\n",(float)statist->wait_time/all );
    printf("mesos xronos e3ipiretisis: %f\n",statist->e3ipiretisi_time/all );
    printf("metafores:");
    
    for(i=0;i<100;i++)
    {
        if(statist->transfer[i]==0)
        {
            break;
        }
        printf("%d ",statist->transfer[i]);
    }
    printf("\nplano kratiseon\nzoni A:[");
    for(i=0;i<A_NUM;i++)
    {
        printf("%d ",plano->A[i]);        
    }
    printf("]\nzoni B:[");
    for(i=0;i<B_NUM;i++)
    {
        printf("%d ",plano->B[i]);        
    }
    printf("]\nzoni C:[");
    for(i=0;i<C_NUM;i++)
    {
        printf("%d ",plano->C[i]);        
    }
    printf("]\nzoni D:[");
    for(i=0;i<D_NUM;i++)
    {
        printf("%d ",plano->D[i]);        
    }
    printf("]\n");
    
    sem_post(sem_data);
    
    printf("\nsinolika xrimata %d\n",money );
}

int main() 
{

    struct sigaction sa;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = 0;
    sa.sa_handler = sig_chld;
            
        
    sd = socket(AF_UNIX, SOCK_STREAM, 0);
    /*Checking if the socket failed to be created*/
    if ( sd < 0)
    { 
        perror("unable to create socket" );
        exit(1);
    }
        
    /*Create the address we will be binding to.*/
    struct sockaddr addr;        
    addr.sa_family = AF_UNIX;
    strcpy(addr.sa_data, SOCK_NAME);

    //unlink for safety
    unlink(SOCK_NAME);
    int size = sizeof(addr.sa_family) + strlen(addr.sa_data);
    
    if(bind(sd, &addr, size) < 0) 
    {
        perror("Unable to bind socket" );
        exit(1);
    }
    
    thesis_num=A_NUM+B_NUM+C_NUM+D_NUM;
    int shm_size=3*sizeof(int)+sizeof(thesis_t) + sizeof(statistics) + 3*sizeof(sem_t);
    shm_id = shmget(SHM_KEY, shm_size, 0600|IPC_CREAT);
    if (shm_id < 0)
    {
        perror("Could not create shared memory!\n");
        exit(1);
    }
    
    init_share_mem();
    memset(data,0,shm_size);
    

    sem_init(sem_tilef,1,N_COMPANY);
    sem_init(sem_bank,1,N_BANK);
    sem_init(sem_data,1,1);

    signal( SIGCHLD, sig_chld ); /*Avoid "zombie" process generation. */
    signal( SIGINT, safe_exit); /*Handle Control + C termination */
    signal( SIGTERM, safe_exit); /*Handle termination signal termination */
    
    init_random();       
                
        
    int pid=fork();
    /*check if fork faild */
    if(pid<0)
    {
        perror("Unable to create child process" );
        exit(1);
    }
    else if(pid==0)
    {
        transfer_money();
    }
    
    if(listen(sd,SOMAXCONN) < 0) 
    {
        perror("Unable to bind socket" );
        exit(1);
    }                        
    
    while(1)
    {
        int ns = accept(sd, NULL, NULL);        
        /*Checking if the server failed to accept a connection*/
        if ( ns < 0) 
        { 
            perror("Unable to accept" );
            exit(1);
        }
        
        pid=fork();
        /*check if fork faild */
        if(pid<0)
        {
            perror("Unable to create child process" );
            exit(1);
        }            
        if(pid==0)
        {
            child_proces_tilefonitis(ns);
        }          
        close(ns);
    }
}

void init_share_mem()
{
    data = shmat(shm_id, NULL, 0);     
        
    if ( (char*) data == (char *)-1) 
    {
        printf("Could not attach to shared memory!\n"); 
        exit(1);
    } 

    //data always show at the start of the share memory
    void *p=data;
    /*initialize the pointers to share memory*/
    sem_bank=(sem_t*)p;
    p+=sizeof(sem_t);
    sem_tilef=(sem_t*)p;
    p+=sizeof(sem_t);
    sem_data=(sem_t*)p;
    p+=sizeof(sem_t);
    full=(int*)p;
    p+=sizeof(int);
    company_account=(int*)p;
    p+=sizeof(int);
    theater_account=(int*)p;
    p+=sizeof(int);
    plano=(thesis_t*)p;    
    p+=sizeof(thesis_t);
    statist = (statistics*)p;
}

void check_card(int sig) 
{    
    //we are at tilefonitis proccess
    //we return immediately
    if(pid_bank!=0)
    {
        return ;
    }
    sem_wait(sem_bank);    
    
    init_random();
    my_sleep(T_CARDCHECK);

    int r=get_rand(9);
    sem_post(sem_bank);
    
    if(r==0)
    {
        exit(1);
    }
    exit(0);
}

void child_proces_tilefonitis(int ns)
{
    init_share_mem();
    signal( SIGCHLD, 0 );
    signal( SIGINT, safe_exit_child); /*signal for termination of the process */
    signal( SIGTERM, safe_exit_child ); /*signal for termination of the process */
    
     /*
      * Prosthetoume ton handler ston patera oste na ton klironomisi to child process. 
      * Me afto ton tropo den iparxei kapio diastima kata to opoio tha exei ekinithei to paidi alla to SIGALRM na min exei handler
      * i check_card elenxei se pio process briskete
      */
    signal( SIGALRM, check_card);
    
    //we create another child process to send messages for the waiting time
    //later this proccess will check the credit card after an alarm signal
    pid_bank=fork();
    if(pid_bank<0)
    {
        perror("Unable to fork");
        my_write(ns,FINISH);   
        shmdt(data);        
        exit(0);
    }    
    else if(pid_bank==0)//child proccess 
    {
        
        while(1) /*we leave this loop when we receive an  alarm signal */
        {
            my_sleep(T_WAIT);
            my_write(ns,WAIT_MSG);
        }
    }
    
    //metrame ton xrono kathisterisis 3ekinontas apo tora
    time_t wait_time=time(NULL);
    
    /*desmeboume enan tilefoniti 
     *an den iparxi diathesimos perimenoume 
     */
    sem_wait(sem_tilef);    
    
    //telikos xronos kathisterisis
    time_t timer=time(NULL); 
    wait_time=timer-wait_time;
    
    tickets_t ticket;
    if(read(ns,&ticket,sizeof(tickets_t) ) < 0 )
    { 
        perror("unable to read from the socket" );
        sem_post(sem_tilef);
        
        kill(pid_bank, SIGTERM);
        waitpid( pid_bank, NULL, WNOHANG ); /*for zobie processes*/
        shmdt(data); 
        exit(1);
    }

    //elenxos an to theatro einai gemato
    //o elenxos ginete amesos kathos den xriazete na psa3oume gia adies thesis
    sem_wait(sem_data);    //critical data section for pointer full
    
    if(*full==thesis_num)
    {
        sem_post(sem_data);
        
        kill(pid_bank, SIGTERM);
        waitpid( pid_bank, NULL, WNOHANG ); /*for zobie processes*/
        my_write(ns,FULL_MSG);
        child_finish(ns,0,wait_time,timer);
        sem_post(sem_tilef);
        shmdt(data);   
        exit(0);
    }
    else
    {
        sem_post(sem_data);
        
    }
     
//  send alarm signal to inform the process to procced to credit card check
    kill(pid_bank, SIGALRM);
    
    my_sleep(T_SEATFIND);
    int stat;    
    
    //we wait for the bank process to terminate
    pid_bank=waitpid( pid_bank, &stat, 0 );     
    //if the exit code is not 0 then the card check have been denied
    int chld_exit_status=WEXITSTATUS(stat);    
    if(chld_exit_status!=0) // the credit card did not be accepted
    {
        my_write(ns,CARD_FAILD);   
        child_finish(ns,0,wait_time,timer);   
        sem_post(sem_tilef);
        shmdt(data);   
        
        exit(0);
    }
    
    int money;
    int current_thesis[4];//oi theseis pou tha parei o xrisis (to poly 4)
    memset(current_thesis,0,4);//arxikopoisei sto 0
        
    int my_pid=getpid();
    int thesis_found=0;
      
    
    int i;
    int *zone_array;//mas dixni to array gia tin zoni pou diale3e o xrises
    int zone_max; //mas dixni to megisto aritho theseon gia tin sigekrimeni zoni
    
    if(ticket.zone == 'A')
    {
        money = 50 * ticket.num;
        zone_max=A_NUM;
        zone_array=plano->A;
    }
    else if(ticket.zone == 'B')
    {
        money = 40 * ticket.num;
        zone_max=B_NUM;
        zone_array=plano->B;
    }
    else if(ticket.zone == 'C')
    {
        money = 35 * ticket.num;
        zone_max=C_NUM;
        zone_array=plano->C;
    }
    else
    {
        money = 30 * ticket.num;
        zone_max=D_NUM;
        zone_array=plano->D;
    }
    
    sem_wait(sem_data);    //critical data section  
    
    //elenxos gia kenes thesis    
    for(i=0;i<zone_max;i++)
    {
        //ama i thesi einai 0 tote einai kenh
        if(zone_array[i]==0)
        {
            //to anagnoristiko tis kratisis ine to pid
            zone_array[i]=my_pid;
            current_thesis[thesis_found]=i;//apothikeboume tin keni thesi pou brikame
            thesis_found++;
            if(thesis_found==ticket.num) //brikame oses theseis xriazomaste
            {
                break;
            }            
        }
    }
    
    /* h kratisi apetixe. 
        adiazoume 3ana tis thesis
    */     
    if(thesis_found!=ticket.num)
    {
        //adiazoume oses theseis exoume idi desmefsi
        for(i=0;i<4;i++)
        {
            int pos=current_thesis[i];            
            //to current_thesis exei arxikopoiithei sto 0. den uparxoun alles theseis desmebmenes
            if(pos<=0)
            {
                break;
            }
            zone_array[pos]=0;
        }
    } 
    else
    {       
        //apothikeboume sto full poses kratisois exoume kanei
        (*full)+=ticket.num;
        (*company_account) += money;
    }
    statist->wait_time+=wait_time;
    sem_post(sem_data);
        
    //elenxoume 3ana gia na kanoume tin parakato diadikasia me anebasmeto ton semaphore
    if(thesis_found==ticket.num) //h kratisi itan epitixis
    {        
        my_write(ns,SUCCESS );
        char buff[50];
        sprintf(buff,ID_MSG,my_pid );        
        my_write(ns,buff);
        sprintf(buff,MONEY_MSG,money );        
        my_write(ns,buff);
        my_write(ns,"oi thesis sas einai:");
        for(i=0;i<ticket.num;i++)
        {
            sprintf(buff,"%c%d ",ticket.zone,current_thesis[i]);
            my_write(ns,buff);
        }
        my_write(ns,"\n");        
        //apothikeboume ta statistika
        child_finish(ns,1,wait_time,timer);
        
        
    }
    else
    {
        my_write(ns,NO_SEATS );
        //apothikeboume ta statistika
        child_finish(ns,0,wait_time,timer);
    }
    
    sem_post(sem_tilef);
    shmdt(data);    
    
    exit(0);
}

