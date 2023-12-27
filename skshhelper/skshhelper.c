#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <fcntl.h>

#define BUFSIZE 102400
#define CMDSIZE 512

char line_buffer[BUFSIZE] = {0};
char skshhelper_prefix[] = "/tmp/skshhelper-";
FILE *fp;

double sk_open(char* path, char* id) {
  char cmd[CMDSIZE] = {0};
  snprintf(cmd, CMDSIZE, "chmod +x %1$s; ln -sf %1$s %2$s%3$s; %2$s%3$s --appimage-extract-and-run", path, skshhelper_prefix, id);

  printf("skshhelper opening path %s\n", path);
  fp = popen(cmd, "r");
  if (fp == NULL) {
    printf("skshhelper: Error opening command\n");
    return 0.;
  }

  // set fp non-blocking
  int fd = fileno(fp);  
  int flags = fcntl(fd, F_GETFL, 0); 
  flags |= O_NONBLOCK; 
  fcntl(fd, F_SETFL, flags);
  return 1.;
}

double sk_is_open(char* id) {
  if (fp == NULL) {
    return 0.;
  }

  char cmd[CMDSIZE] = {0};
  snprintf(cmd, CMDSIZE, "pgrep -f %s%s | wc -l", skshhelper_prefix, id);
  printf("skshhelper checking is_open %s\n", id);

  FILE *fp_check = popen(cmd, "r");
  if (fp_check == NULL) {
    printf("skshhelper: Error checking pgrep\n");
    return 0.;
  }

  // read first line
  char check_buffer[CMDSIZE] = {0};
  fgets(check_buffer, CMDSIZE, fp_check);
  pclose(fp_check);

  return atoi(check_buffer) > 0 ? 1. : 0.;
}

char* sk_read() {
  if (fp != NULL) {
    if (fgets(line_buffer, BUFSIZE, fp) != NULL) {
      return line_buffer;
    }
  }
  return NULL;
}

double sk_close(char* id) {
  char cmd[CMDSIZE] = {0};
  snprintf(cmd, CMDSIZE, "pkill -f %s%s", skshhelper_prefix, id);
  printf("skshhelper closing %s\n", id);
  system(cmd);
  return 0.;
}

double sk_close_all() {
  char cmd[CMDSIZE] = {0};
  snprintf(cmd, CMDSIZE, "pkill -f %s", skshhelper_prefix);
  printf("skshhelper closing all\n");
  system(cmd);
  return 0.;
}