#include "types.h"
#include "stat.h"
#include "fcntl.h"
#include "user.h"

int main(int argc, char *argv[]){

    if (argc == 3){
        int priority, pid;
        pid = atoi(argv[1]);
        priority = atoi(argv[2]);
        if (priority < 0 || priority > 20){
            printf(2,"Invalid priority (0-20)!\n");
            exit();
        }
        chpr(pid, priority);
        exit();
    }

    if (argc == 1) {
        int num_of_processes = 5;
        for (int i = 0 ; i < num_of_processes ; i++){
            int a = fork();
            if (a < 0){
                while(wait() != -1){
                }
            }

            else if(a == 0) {
                while(1) {}
            }
        }
    }
    
}
