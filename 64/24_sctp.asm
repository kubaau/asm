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

    ; 0     rbp
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
    push rbp                                            ;{
    mov rbp, rsp
    push rbx

                                                        ; int fd_server, fd_client, fd_server_accepted;
                                                        ; struct sockaddr_in server_addr;
                                                        ; char msg_buf[16];
    sub rsp, STACK_END
    and rsp, -16

    ; /* set up server */
    mov rdi, AF_INET
    mov rsi, SOCK_STREAM
    mov rdx, IPPROTO_SCTP
    call socket                                         ; fd_server = socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP);
    mov [rbp - FD_SERVER_OFFSET], eax

    mov word [rbp - SIN_FAMILY_OFFSET], AF_INET         ; server_addr.sin_family = AF_INET;

    mov rdi, 11111
    call htons
    mov [rbp - SIN_PORT_OFFSET], ax                     ; server_addr.sin_port = htons(11111);

    mov rdi, INADDR_LOOPBACK
    call htonl
    mov [rbp - SIN_ADDR_OFFSET], eax                    ; server_addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);

    mov edi, [rbp - FD_SERVER_OFFSET]
    lea rsi, [rbp - SIN_FAMILY_OFFSET]
    mov rdx, SIZEOF_SERVER_ADDR
    call bind                                           ; bind(fd_server, (const struct sockaddr*)&server_addr, sizeof(struct sockaddr_in));

    mov edi, [rbp - FD_SERVER_OFFSET]
    mov rsi, 1
    call listen                                         ; listen(fd_server, 1);

    ; /* set up client */
    mov rdi, AF_INET
    mov rsi, SOCK_STREAM
    mov rdx, IPPROTO_SCTP
    call socket                                         ; fd_client = socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP);
    mov [rbp - FD_CLIENT_OFFSET], eax

    ; /* connect */
    mov rdi, rax
    lea rsi, [rbp - SIN_FAMILY_OFFSET]
    mov rdx, SIZEOF_SERVER_ADDR
    call connect                                        ; connect(fd_client, (const struct sockaddr*)&server_addr, sizeof(struct sockaddr_in));

    mov edi, [rbp - FD_SERVER_OFFSET]
    xor rsi, rsi
    xor rdx, rdx
    call accept                                         ; fd_server_accepted = accept(fd_server, NULL, NULL);
    mov [rbp - FD_SERVER_ACCEPTED_OFFSET], eax

    ; /* send and receive */
    mov rdi, PROMPT
    call printf                                         ; printf("Type message to send (max. 15 chars): ");

    mov rdi, SCANF_FORMAT
    lea rsi, [rbp - SEND_BUF_OFFSET]
    call scanf                                          ; scanf("%s", msg_buf);

    mov rdi, SEND_FORMAT
    lea rsi, [rbp - SEND_BUF_OFFSET]
    call printf                                         ; printf("Sending %s\n", msg_buf);

    mov edi, [rbp - FD_CLIENT_OFFSET]
    lea rsi, [rbp - SEND_BUF_OFFSET]
    mov rdx, SEND_BUF_SIZE
    xor rcx, rcx
    call send                                           ; send(fd_client, msg_buf, sizeof(msg_buf), 0);

    mov edi, [rbp - FD_SERVER_ACCEPTED_OFFSET]
    lea rsi, [rbp - RECV_BUF_OFFSET]
    mov rdx, RECV_BUF_SIZE
    call recv                                           ; recv(fd_server_accepted, msg_buf, sizeof(msg_buf), 0);

    mov rdi, RECV_FORMAT
    lea rsi, [rbp - RECV_BUF_OFFSET]
    call printf                                         ; printf("Received %s\n", msg_buf);

    ; /* clean up */
    xor rdi, rdi
    mov edi, [rbp - FD_SERVER_ACCEPTED_OFFSET]
    call close                                          ; close(fd_server_accepted);
    mov edi, [rbp - FD_CLIENT_OFFSET]
    call close                                          ; close(fd_client);
    mov edi, [rbp - FD_SERVER_OFFSET]
    call close                                          ; close(fd_server);

.done:
    pop rbx
    mov rsp, rbp
    pop rbp
    xor rax, rax
    ret ; main                                          ;}
