#include <stdio.h>
#include <signal.h>

#ifdef _WIN32
#include <windows.h>
#else
#include <unistd.h>
#include <netdb.h>
#include <sys/socket.h>
#include <sys/time.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <stdarg.h>
#include <sys/ioctl.h>
#include <sys/errno.h>
#include <sys/resource.h>
#ifdef SOLARIS
#include <sys/filio.h>
#include <errno.h>
#endif
#endif

#ifndef _WIN32
typedef int        SOCKET;
#endif

#define DELIM "\x001"
#define BUF_LEN 512
#define BUF_OVERFLOW 0

int Net_Init(void);
void Net_Exit(void);
int Net_Listen(int port);
void Net_StopListen(void);
SOCKET Net_Check(void);
int Net_Lookup(char *host);
SOCKET Net_Connect(int haddr, int port);
int Net_IsConnect(int sock);
//int Net_Poll(SOCKET sock);
int Net_Send(int sock, char *buf);
int Net_Sendf(int sock, char *format, ...);
int Net_Recv(int sock, char *buf, int len);
int Net_Close(SOCKET sock);
char *Net_GetAddrStr(int sock);
int Net_SendTotal(void);
int Net_RecvTotal(void);

void StartTime(void);
int GetTime(void);

void Sys_Sleep(int msec);
void Split(char *msg, char *s1, unsigned int s1len, char *s2, unsigned int s2len);
void wf_strlwr(char *str);
