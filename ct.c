#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int main(int argc, char *argv[]) {
  int ticket, pid;
  if(argc < 3){
    printf(2,"Usage: nice pid priority\n");
    exit();
  }

  pid = atoi(argv[1]);
  ticket = atoi(argv[2]);

  if (ticket < 0 || ticket > 2000){
    printf(2,"Invalid priority (0-20)!\n");
    exit();
  }

  changeTicket(pid, ticket);
  exit();
}