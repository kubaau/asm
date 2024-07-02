global main

extern accept
extern bind
extern close
extern connect
extern htonl
extern htons
extern listen
extern printf
extern recv
extern scanf
extern send
extern socket

section .rodata
    PROMPT: db "Type message to send (max. 15 chars): ", 0
    SCANF_FORMAT: db "%s", 0
    SEND_FORMAT: db "Sending %s", 10, 0
    RECV_FORMAT: db "Received %s", 10, 0

    AF_INET: equ 2
    SOCK_STREAM: equ 1
    IPPROTO_SCTP: equ 132
    INADDR_LOOPBACK: equ 0x7f000001

    SIZEOF_SHORT: equ 2
    SIZEOF_INT: equ 4
    SIZEOF_SERVER_ADDR: equ 16
    SEND_BUF_SIZE: equ 16
    RECV_BUF_SIZE: equ SEND_BUF_SIZE

    ; 0     ebp
    ; -4    fd_server
    ; -8    fd_client
    ; -12   fd_server_accepted
    ;
    ; -16   server_addr.sin_addr
    ; -18   server_addr.sin_port
    ; -20   server_addr.sin_family
    ;
    ; -28   msg_buf
    ; -44   rsp

    FD_SERVER_OFFSET: equ SIZEOF_INT
    FD_CLIENT_OFFSET: equ FD_SERVER_OFFSET + SIZEOF_INT
    FD_SERVER_ACCEPTED_OFFSET: equ FD_CLIENT_OFFSET + SIZEOF_INT
    SIN_ADDR_OFFSET: equ FD_SERVER_ACCEPTED_OFFSET + SIZEOF_INT
    SIN_PORT_OFFSET: equ SIN_ADDR_OFFSET + SIZEOF_SHORT
    SIN_FAMILY_OFFSET: equ SIN_PORT_OFFSET + SIZEOF_SHORT
    SEND_BUF_OFFSET: equ FD_SERVER_ACCEPTED_OFFSET + SIZEOF_SERVER_ADDR
    RECV_BUF_OFFSET: equ SEND_BUF_OFFSET + SEND_BUF_SIZE
    STACK_END: equ RECV_BUF_OFFSET + RECV_BUF_SIZE

section .text

main:                                                   ;int main(int argc, char** argv)
    push ebp                                            ;{
    mov ebp, esp

                                                        ; int fd_server, fd_client, fd_server_accepted;
                                                        ; struct sockaddr_in server_addr;
                                                        ; char msg_buf[16];
    sub esp, STACK_END
    and esp, -16

    ; /* set up server */
    push IPPROTO_SCTP
    push SOCK_STREAM
    push AF_INET
    call socket                                         ; fd_server = socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP);
    add esp, 12
    mov [ebp - FD_SERVER_OFFSET], eax

    mov word [ebp - SIN_FAMILY_OFFSET], AF_INET         ; server_addr.sin_family = AF_INET;

    push 11111
    call htons
    add esp, 4
    mov [ebp - SIN_PORT_OFFSET], ax                     ; server_addr.sin_port = htons(11111);

    push INADDR_LOOPBACK
    call htonl
    add esp, 4
    mov [ebp - SIN_ADDR_OFFSET], eax                    ; server_addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);

    push SIZEOF_SERVER_ADDR
    lea eax, [ebp - SIN_FAMILY_OFFSET]
    push eax
    push dword [ebp - FD_SERVER_OFFSET]
    call bind                                           ; bind(fd_server, (const struct sockaddr*)&server_addr, sizeof(struct sockaddr_in));
    add esp, 12

    push 1
    push dword [ebp - FD_SERVER_OFFSET]
    call listen                                         ; listen(fd_server, 1);
    add esp, 8

    ; /* set up client */
    push IPPROTO_SCTP
    push SOCK_STREAM
    push AF_INET
    call socket                                         ; fd_client = socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP);
    mov [ebp - FD_CLIENT_OFFSET], eax
    add esp, 12

    ; /* connect */
    push SIZEOF_SERVER_ADDR
    lea ebx, [ebp - SIN_FAMILY_OFFSET]
    push ebx
    push eax
    call connect                                        ; connect(fd_client, (const struct sockaddr*)&server_addr, sizeof(struct sockaddr_in));
    add esp, 12

    push 0
    push 0
    push dword [ebp - FD_SERVER_OFFSET]
    call accept                                         ; fd_server_accepted = accept(fd_server, NULL, NULL);
    mov [ebp - FD_SERVER_ACCEPTED_OFFSET], eax
    add esp, 12

    ; /* send and receive */
    push PROMPT
    call printf                                         ; printf("Type message to send (max. 15 chars): ");
    add esp, 4

    lea eax, [ebp - SEND_BUF_OFFSET]
    push eax
    push SCANF_FORMAT
    call scanf                                          ; scanf("%s", msg_buf);
    add esp, 4

    push SEND_FORMAT
    call printf                                         ; printf("Sending %s\n", msg_buf);
    add esp, 8

    push 0
    push SEND_BUF_SIZE
    lea eax, [ebp - SEND_BUF_OFFSET]
    push eax
    push dword [ebp - FD_CLIENT_OFFSET]
    call send                                           ; send(fd_client, msg_buf, sizeof(msg_buf), 0);
    add esp, 8

    lea eax, [ebp - RECV_BUF_OFFSET]
    push eax
    push dword [ebp - FD_SERVER_ACCEPTED_OFFSET]
    call recv                                           ; recv(fd_server_accepted, msg_buf, sizeof(msg_buf), 0);
    add esp, 16

    lea eax, [ebp - RECV_BUF_OFFSET]
    push eax
    push RECV_FORMAT
    call printf                                         ; printf("Received %s\n", msg_buf);
    add esp, 8

    ; /* clean up */
    push dword [ebp - FD_SERVER_ACCEPTED_OFFSET]
    call close                                          ; close(fd_server_accepted);
    add esp, 4
    push dword [ebp - FD_CLIENT_OFFSET]
    call close                                          ; close(fd_client);
    add esp, 4
    push dword [ebp - FD_SERVER_OFFSET]
    call close                                          ; close(fd_server);
    add esp, 4

.done:
    mov esp, ebp
    pop ebp
    xor eax, eax
    ret ; main                                          ;}
