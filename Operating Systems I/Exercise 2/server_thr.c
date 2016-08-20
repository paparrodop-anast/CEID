#include"header.h"
#include <sys/types.h> /* basic system data types */
#include <sys/socket.h> /* basic socket definitions */
#include<stdlib.h>
#include <unistd.h>
#include <string.h> /*string operations*/
#include <errno.h> /* for the EINTR constant */
#include <stdio.h>
#include<pthread.h>
#include <time.h>
#include<signal.h>
#include<sys/time.h>

#include"header.h"

#define N_COMPANY 10
#define N_BANK 4

#define T_SEATFIND 6
#define T_CARDCHECK 2
#define T_WAIT 10
#define T_TRANSFER 30

#define A_NUM 100
#define B_NUM 130
#define C_NUM 180
#define D_NUM 230
#define THESIS_NUM A_NUM+B_NUM+C_NUM+D_NUM

#define SUCCESS "H kratisi oloklirothike epitixos.\n"
#define ID_MSG "To anagnoristiko tis einai %d.\n"
#define MONEY_MSG "To sinoliko kostos tis kratisis sas einai %d.\n"

#define NO_SEATS "den iparxoun diathesimes thesis stin sigekrimeni zoni\n"
#define CARD_FAILD "h pistotiki sas karta den egine apodexth\n"
#define WAIT_MSG "signomi gia tin kathisterisi\n"

int tilef_num; //oi tilefonites
pthread_mutex_t data_mutex ;//mutex gia tin prosbasi stis thesis
pthread_mutex_t tilef_mutex ;//mutex gia tous tilefonites
pthread_cond_t  tilef_cond  ;//condition gia tous tilefonites
pthread_mutex_t bank_mutex; //mutex gia ton elenxo tis kartas
pthread_cond_t  bank_cond  ;//condition gia tous trapezites
int bank_num;//oi trapezites

int sd; //to socket
int kratisi_id; //id gia tin kathe kratisi
int company_account; //trapezikos logariasmou tilefonikis eterias
int theater_account; //trapezikos logariasmou theatrou
int full;

pthread_t thr_transfer;

struct thesis_t
{
    int A[A_NUM];
    int B[B_NUM];
    int C[C_NUM];
    int D[D_NUM];
} plano; //to sinolo ton theseon

struct statistics
{
    int fail;
    int succeded;
    time_t wait_time;
    time_t e3ipiretisi_time;
    int transfer[100];
} statist;


void print_stat()
{
    
    pthread_mutex_lock(&data_mutex);//critical data section. Conflict with transfer_money
    
    int money=theater_account + company_account;
    
    
    int i;
    float all=statist.fail+statist.succeded;
    printf("pososto apotixias: %f\n",(float)statist.fail/all);
    printf("mesos xronos anamonis: %f\n",(float)statist.wait_time/all );
    printf("mesos xronos e3ipiretisis: %f\n",statist.e3ipiretisi_time/all );
    printf("metafores:");
    
    for(i=0;i<100;i++)
    {
        if(statist.transfer[i]==0)
        {
            break;
        }
        printf("%d ",statist.transfer[i]);
    }
    printf("\nplano kratiseon\nzoni A:[");
    for(i=0;i<A_NUM;i++)
    {
        printf("%d ",plano.A[i]);        
    }
    printf("]\nzoni B:[");
    for(i=0;i<B_NUM;i++)
    {
        printf("%d ",plano.B[i]);        
    }
    printf("]\nzoni C:[");
    for(i=0;i<C_NUM;i++)
    {
        printf("%d ",plano.C[i]);        
    }
    printf("]\nzoni D:[");
    for(i=0;i<D_NUM;i++)
    {
        printf("%d ",plano.D[i]);        
    }
    printf("]\n");
    
    pthread_mutex_unlock(&data_mutex);//unlock the mutex
    
    printf("\nsinolika xrimata %d\n",money );
}

void safe_exit() /*exit at iterapt and terminate signal */
{ 
    close(sd);//klinoume to socket oste na min mpoune ali cliend
    
    
    /*
     * perimenoume na teliosoun osoi cliend exoun idi sindethi
     * afto to petixenoume perimenontas sto condition.
     */
    pthread_mutex_lock(&tilef_mutex);
    while(tilef_num!=N_COMPANY)
    {
        pthread_cond_wait(&tilef_cond, &tilef_mutex);        
    }
    pthread_mutex_unlock(&tilef_mutex);
    

    //kanoume cancel to thread tis metaforas xrimaton
    pthread_cancel(thr_transfer);
    //perimenoume na termatisi to thread
    pthread_join(thr_transfer,NULL);
    
    //ektiponoume ta statistika
    print_stat();
    
    //kanoume to teliko katharisma
    pthread_mutex_destroy(&data_mutex);
    pthread_mutex_destroy(&tilef_mutex);
    pthread_mutex_destroy(&bank_mutex);
    pthread_cond_destroy(&tilef_cond);
    pthread_cond_destroy(&bank_cond);
    unlink(SOCK_NAME);

    exit(0);        
}

void* transfer_money( )
{
    int i=0;
    while(1)
    {   
        /*
         * Orizoume to thread na termatisi ama labi sima cancel
         */
        pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS,NULL);
        my_sleep(T_TRANSFER);
        
        /*
         * orizoume to thread na min ginete cancel oso diarki i metafora xrimaton
         */
        pthread_setcanceltype(PTHREAD_CANCEL_DISABLE,NULL);
        pthread_mutex_lock(&data_mutex);//critical data section
        if(company_account>0)
        {
            theater_account += company_account;
            statist.transfer[i]=company_account;
            company_account=0;
            i++;
        }        
        pthread_mutex_unlock(&data_mutex);//unlock the mutex
        
    }
}

void* tilefonitis(void*);

void *bank(void *arg)
{
    /*
     * desmeboume enan trapeziti 
     *an den iparxi diathesimos perimenoume 
     */
    
    //arxika klidonoume to mutex
    pthread_mutex_lock(&bank_mutex);
    //perimenoume sto condition mexri na iparxi eleftheros trapezitis
    while(bank_num==0)
    {
        pthread_cond_wait(&bank_cond, &bank_mutex);
    }
    //exoume pleon apoktisi protereotita. mionoume ton aritho ton eleftheron tilefoniton
    bank_num--;
    //3eklidonoume to mutex
    pthread_mutex_unlock(&bank_mutex);
            
    my_sleep(T_CARDCHECK);

    int r=get_rand(9);   
    
    int *ret=(int*)malloc(sizeof(int) );
    if(r==0)
    {
        *ret=1;
    }
    else
    {
        *ret=0;
    }
    
    //klidonoune to mutex
    pthread_mutex_lock(&bank_mutex);
    //af3anoume ton aritho ton eleftheron trapiziton
    bank_num++;
    //3ipname kapio thread pou perimeni sto condition
    pthread_cond_signal(&bank_cond); 
    //eleftheronoume to mutex
    pthread_mutex_unlock(&bank_mutex); 

    pthread_exit(ret);    
}


int main() 
{
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

    init_random();       

    if(listen(sd,SOMAXCONN) < 0) 
    {
        perror("Unable to bind socket" );
        exit(1);
    }            
    
    full=0;
    kratisi_id=0;
        
    
    //initialize the conditions and mutexes    
    pthread_mutex_init(&tilef_mutex,NULL);
    pthread_mutex_init(&bank_mutex,NULL);
    pthread_mutex_init(&data_mutex,NULL);
    pthread_cond_init(&bank_cond,NULL);
    pthread_cond_init(&tilef_cond,NULL);
    
    pthread_create(&thr_transfer, NULL, &transfer_money, NULL);
    
    signal( SIGINT, safe_exit ); /*signal for termination of the process */
    signal( SIGTERM, safe_exit ); /*signal for termination of the process */
    
    tilef_num=N_COMPANY;
    bank_num=N_BANK;
    
    while(1)
    {
        //malloc int for accepting the socket
        int *ns=(int*)malloc(sizeof(int));
        *ns = accept(sd, NULL, NULL);        
        /*Checking if the server failed to accept a connection*/
        if ( *ns < 0) 
        { 
            perror("Unable to accept" );
            exit(1);
        }
        
        // oi tilefonites den einai detached
        pthread_attr_t attr;
        pthread_attr_init(&attr);
        pthread_attr_setdetachstate(&attr,PTHREAD_CREATE_DETACHED);
            
        pthread_t id;
        pthread_create(&id, &attr, &tilefonitis, (void*)ns);
    }
}

/*
 * clinoum to socket kanoume to teliko cleanup kai termatizoume
 */
void tilefonitis_exit(int *ns)
{
    /*
    * exoume pleon teliosi opete eleftheronoume ton tilefoniti
    */  

    close(*ns);
    ns=0;
    pthread_mutex_lock(&tilef_mutex);//klidonoune to mutex    
    tilef_num++;//af3anoume ton aritho ton eleftheron tilefoniton
    pthread_cond_signal(&tilef_cond); //3ipname kapio thread pou perimeni sto condition
    pthread_mutex_unlock(&tilef_mutex); //eleftheronoume to mutex
        
    free(ns);    
    pthread_exit(NULL);//kanoume exit
}

/*
 * o tilefonitis teliose. Enimeronoume ton cliend kai apothikeboume ta statistika
 */
void tilefonitis_finish(int *ns, int succeded,time_t wait_time,time_t timer)
{    
    //stelnoume mnm gia ston cliend
    my_write(*ns,FINISH);
    
    /*
     * enimeronoume to statistika
     */
    time_t e3ipiretisi_time = time(NULL) - timer;
    pthread_mutex_lock(&data_mutex);
    
    if(succeded>0)
    {
        statist.succeded++; 
        succeded=statist.succeded;
    }
    else
    {
        statist.fail++;
    }
    
    statist.wait_time+=wait_time;
    statist.e3ipiretisi_time+=e3ipiretisi_time;
    pthread_mutex_unlock(&data_mutex);
    tilefonitis_exit(ns);
}

void* tilefonitis(void *arg )
{
    int *ns=(int*)arg;
    
    //metrame ton xrono kathisterisis 3ekinontas apo tora
    time_t wait_time=time(NULL);
    
    /*desmeboume enan tilefoniti 
     *an den iparxi diathesimos perimenoume 
     */            
    
    //arxika klidonoume to mutex    
    pthread_mutex_lock(&tilef_mutex);   
    
    //perimenoume sto condition mexri na iparxi eleftheros tilefonitis h gia T_WAIT time.
    //meta apo kathe T_WAIT time grafoume to minima sto socket kai perimenoume 3ana
    while(tilef_num==0)
    {
        struct timeval tv;
        gettimeofday(&tv,NULL);        
        struct timespec t_tilefonitis_time;
        t_tilefonitis_time.tv_sec=tv.tv_sec + T_WAIT;
        t_tilefonitis_time.tv_nsec=tv.tv_usec*1000;
        
        int err=pthread_cond_timedwait(&tilef_cond, &tilef_mutex,&t_tilefonitis_time);        
        
        //to condition epestrepse epidi perasan T_WAIT defterolepta
        if(err==ETIMEDOUT)
        {
            pthread_mutex_unlock(&tilef_mutex);
            my_write(*ns,WAIT_MSG);
            pthread_mutex_lock(&tilef_mutex);
        }
    }
    
    //exoume pleon apoktisi protereotita. mionoume ton aritho ton eleftheron tilefoniton
    tilef_num--;
    //3eklidonoume to mutex
    pthread_mutex_unlock(&tilef_mutex);
    
     //telikos xronos kathisterisis
    time_t time_now=time(NULL); 
    wait_time=time_now-wait_time;
        
    tickets_t ticket;
    if(read(*ns,&ticket,sizeof(tickets_t) ) < 0 )
    { 
        perror("unable to read from the socket" );        
        tilefonitis_exit(ns);        
    }

    //elenxos an to theatro einai gemato
    //o elenxos ginete amesos kathos den xriazete na psa3oume gia adies thesis
    pthread_mutex_lock(&data_mutex);    //critical data section for pointer full
    
    if(full==THESIS_NUM)
    {
        pthread_mutex_unlock(&data_mutex);        
        my_write(*ns,FULL_MSG);
        tilefonitis_finish(ns,0,wait_time,time_now);
    }
    else
    {
        pthread_mutex_unlock(&data_mutex);
    }

    //to thread tis trapezas einai joinable
    pthread_attr_t attr;
    pthread_attr_init(&attr);
    pthread_attr_setdetachstate(&attr,PTHREAD_CREATE_JOINABLE);
    
    pthread_t thr_bank;
    pthread_create(&thr_bank, &attr, bank, NULL);
    
    int *bank_return;
    my_sleep(T_SEATFIND);    
    
    //perimenoume na teliosi to thread tis trapezas kai pernoume to exis status tou
    pthread_join(thr_bank,(void**)&(bank_return) );
    
    pthread_attr_destroy(&attr);//den xriazomaste a attributes pleon
        
    if(*bank_return!=0) // i pistotiki den egine dexti
    {
        my_write(*ns,CARD_FAILD);   
        free(bank_return);
        //stelnoume minima termatismou ston cliend kai termatizoume kai to thread
        tilefonitis_finish(ns,0,wait_time,time_now);
    }
    else
    {
        //i karta egine apodexth. pleon den xriazomaste to bank_return 
        free(bank_return);
    }
    
    /*
     * Tora briskoume tis thesois ston pinaka kratiseon
     */
    
    int money;
    //oi theseis pou tha parei o xrisis (to poly 4)
    int current_thesis[4];
    //arxikopoisei sto 0
    memset(current_thesis,0,4);
        
    int thesis_found=0;
          
    int i;
    //mas dixni to array gia tin zoni pou diale3e o xrises
    int *zone_array;
     //mas dixni to megisto aritho theseon gia tin sigekrimeni zoni
    int zone_max;
    
    if(ticket.zone == 'A')
    {
        money = 50 * ticket.num;
        zone_max=A_NUM;
        zone_array=plano.A;
    }
    else if(ticket.zone == 'B')
    {
        money = 40 * ticket.num;
        zone_max=B_NUM;
        zone_array=plano.B;
    }
    else if(ticket.zone == 'C')
    {
        money = 35 * ticket.num;
        zone_max=C_NUM;
        zone_array=plano.C;
    }
    else
    {
        money = 30 * ticket.num;
        zone_max=D_NUM;
        zone_array=plano.D;
    }
    
    //critical data section  
    pthread_mutex_lock(&data_mutex);      
    
    //af3anoume ton aritho tis kratisis
    //xrisimopioume to kratisi_id san id giati meta to peras tou thread kapio alo mpori na pari tixea to idio id
    kratisi_id++;
    
    //elenxos gia kenes thesis    
    for(i=0;i<zone_max;i++)
    {
        //ama i thesi einai 0 tote einai kenh
        if(zone_array[i]==0)
        {
            //to anagnoristiko tis kratisis ine to kratisi_id.
            zone_array[i]=kratisi_id;
            ;//apothikeboume tin keni thesi pou brikame
            current_thesis[thesis_found]=i;
            thesis_found++;
            //brikame oses theseis xriazomaste
            if(thesis_found==ticket.num) 
            {
                break;
            }            
        }
    }    

    //elenxoume an h kratisi apetixe. kai adiazoume 3ana tis thesis    
    if(thesis_found!=ticket.num)
    {
        //adiazoume oses theseis exoume idi desmefsi
        for(i=0;i<thesis_found;i++)
        {
            int pos=current_thesis[i];            
            zone_array[pos]=0;
        }        
        //h kratisi den egine. mionoume ton aritho kratisis
        kratisi_id--;
    } 
    else
    {       
        //apothikeboume sto full poses kratisois exoume kanei
        full+=ticket.num;
        company_account += money;
    }
    
    pthread_mutex_unlock(&data_mutex);
        
    //elenxoume 3ana gia na kanoume tin parakato diadikasia me 3eklidoto to mutex
    if(thesis_found==ticket.num) //h kratisi itan epitixis
    {        
        my_write(*ns,SUCCESS );
        char buff[50];
        sprintf(buff,ID_MSG,kratisi_id );        
        my_write(*ns,buff);
        sprintf(buff,MONEY_MSG,money );        
        my_write(*ns,buff);
        my_write(*ns,"oi thesis sas einai:");
        for(i=0;i<ticket.num;i++)
        {
            sprintf(buff,"%c%d ",ticket.zone,current_thesis[i]);
            my_write(*ns,buff);
        }
        my_write(*ns,"\n");        
        //apothikeboume ta statistika
        tilefonitis_finish(ns,1,wait_time,time_now);
    }
    else
    {
        my_write(*ns,NO_SEATS );
        //apothikeboume ta statistika
        tilefonitis_finish(ns,0,wait_time,time_now);
    } 
    
    return NULL;
}

