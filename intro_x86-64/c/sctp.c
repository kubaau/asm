#include <arpa/inet.h>
#include <netinet/sctp.h>
#include <stdio.h>
#include <unistd.h>

int main(void)
{
    int fd_server, fd_client, fd_server_accepted;
    struct sockaddr_in server_addr;
    char msg_buf[16];

    /* set up server */
    fd_server = socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP);

    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(11111);
    server_addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);

    bind(fd_server, (const struct sockaddr*)&server_addr, sizeof(struct sockaddr_in));
    listen(fd_server, 1);

    /* set up client */
    fd_client = socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP);

    /* connect */
    connect(fd_client, (const struct sockaddr*)&server_addr, sizeof(struct sockaddr_in));
    fd_server_accepted = accept(fd_server, NULL, NULL);

    /* send and receive */
    printf("Type message to send (max. 15 chars): ");
    scanf("%s", msg_buf);

    printf("Sending %s\n", msg_buf);
    send(fd_client, msg_buf, sizeof(msg_buf), 0);

    recv(fd_server_accepted, msg_buf, sizeof(msg_buf), 0);
    printf("Received %s\n", msg_buf);

    /* clean up */
    close(fd_server_accepted);
    close(fd_client);
    close(fd_server);
}
