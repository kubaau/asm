.global main

.extern accept
.extern bind
.extern close
.extern connect
.extern htonl
.extern htons
.extern listen
.extern printf
.extern recv
.extern scanf
.extern send
.extern socket

.section .rodata
    PROMPT: .asciz "Type message to send (max. 15 chars): "
    SCANF_FORMAT: .asciz "%s"
    SEND_FORMAT: .asciz "Sending %s\n"
    RECV_FORMAT: .asciz "Received %s\n"

    .set AF_INET, 2
    .set SOCK_STREAM, 1
    .set IPPROTO_SCTP, 0 @132
    .set INADDR_LOOPBACK, 0x7f000001

    .set SIZEOF_SHORT, 2
    .set SIZEOF_INT, 4
    .set SIZEOF_SERVER_ADDR, 16
    .set SEND_BUF_SIZE, 16
    .set RECV_BUF_SIZE, SEND_BUF_SIZE

    @ ; 0     r11
    @ ; -4    fd_server
    @ ; -8    fd_client
    @ ; -12   fd_server_accepted
    @ ;
    @ ; -16   server_addr.sin_addr
    @ ; -18   server_addr.sin_port
    @ ; -20   server_addr.sin_family
    @ ;
    @ ; -28   msg_buf
    @ ; -44   sp

    .set FD_SERVER_OFFSET, SIZEOF_INT
    .set FD_CLIENT_OFFSET, FD_SERVER_OFFSET + SIZEOF_INT
    .set FD_SERVER_ACCEPTED_OFFSET, FD_CLIENT_OFFSET + SIZEOF_INT
    .set SIN_ADDR_OFFSET, FD_SERVER_ACCEPTED_OFFSET + SIZEOF_INT
    .set SIN_PORT_OFFSET, SIN_ADDR_OFFSET + SIZEOF_SHORT
    .set SIN_FAMILY_OFFSET, SIN_PORT_OFFSET + SIZEOF_SHORT
    .set SEND_BUF_OFFSET, FD_SERVER_ACCEPTED_OFFSET + SIZEOF_SERVER_ADDR
    .set RECV_BUF_OFFSET, SEND_BUF_OFFSET + SEND_BUF_SIZE
    .set STACK_END, RECV_BUF_OFFSET + RECV_BUF_SIZE

.text
main:
    push {r11, lr}              @     push rbp                                            ;{
    mov r11, sp                 @     mov rbp, rsp
                                @     push rbx

                                @                                                         ; int fd_server, fd_client, fd_server_accepted;
                                @                                                         ; struct sockaddr_in server_addr;
                                @                                                         ; char msg_buf[16];
    ldr r0, =STACK_END
    sub sp, r0                  @     sub rsp, STACK_END
    and sp, #-16                @     and rsp, -16

                                @     ; /* set up server */
    ldr r0, =AF_INET            @     mov rdi, AF_INET
    ldr r1, =SOCK_STREAM        @     mov rsi, SOCK_STREAM
    ldr r2, =IPPROTO_SCTP       @     mov rdx, IPPROTO_SCTP
    bl socket                   @     call socket                                         ; fd_server = socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP);
    ldr r1, =FD_SERVER_OFFSET
    neg r1, r1
    str r0, [r11, r1]           @     mov [rbp - FD_SERVER_OFFSET], eax

    ldr r0, =AF_INET
    ldr r1, =SIN_FAMILY_OFFSET
    neg r1, r1
    str r0, [r11, r1]           @     mov word [rbp - SIN_FAMILY_OFFSET], AF_INET         ; server_addr.sin_family = AF_INET;

    ldr r0, =11111              @     mov rdi, 11111
    bl htons                    @     call htons
    ldr r1, =SIN_PORT_OFFSET
    neg r1, r1
    strh r0, [r11, r1]          @     mov [rbp - SIN_PORT_OFFSET], ax                     ; server_addr.sin_port = htons(11111);

    ldr r0, =INADDR_LOOPBACK    @     mov rdi, INADDR_LOOPBACK
    bl htonl                    @     call htonl
    ldr r1, =SIN_ADDR_OFFSET
    neg r1, r1
    str r0, [r11, r1]           @     mov [rbp - SIN_ADDR_OFFSET], eax                    ; server_addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);

    ldr r1, =FD_SERVER_OFFSET
    neg r1, r1
    ldr r0, [r11, r1]           @     mov edi, [rbp - FD_SERVER_OFFSET]
    ldr r1, =SIN_FAMILY_OFFSET
    sub r1, r11, r1             @     lea rsi, [rbp - SIN_FAMILY_OFFSET]
    ldr r2, =SIZEOF_SERVER_ADDR @     mov rdx, SIZEOF_SERVER_ADDR
    bl bind                     @     call bind                                           ; bind(fd_server, (const struct sockaddr*)&server_addr, sizeof(struct sockaddr_in));

    ldr r1, =FD_SERVER_OFFSET
    neg r1, r1
    ldr r0, [r11, r1]           @     mov edi, [rbp - FD_SERVER_OFFSET]
    mov r1, #1                  @     mov rsi, 1
    bl listen                   @     call listen                                         ; listen(fd_server, 1);

                                @     ; /* set up client */
    ldr r0, =AF_INET            @     mov rdi, AF_INET
    ldr r1, =SOCK_STREAM        @     mov rsi, SOCK_STREAM
    ldr r2, =IPPROTO_SCTP       @     mov rdx, IPPROTO_SCTP
    bl socket                   @     call socket                                         ; fd_client = socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP);
    ldr r1, =FD_CLIENT_OFFSET
    neg r1, r1
    str r0, [r11, r1]           @     mov [rbp - FD_CLIENT_OFFSET], eax

                                @     ; /* connect */
                                @     mov rdi, rax
    ldr r1, =SIN_FAMILY_OFFSET
    sub r1, r11, r1             @     lea rsi, [rbp - SIN_FAMILY_OFFSET]
    ldr r2, =SIZEOF_SERVER_ADDR @     mov rdx, SIZEOF_SERVER_ADDR
    bl connect                  @     call connect                                        ; connect(fd_client, (const struct sockaddr*)&server_addr, sizeof(struct sockaddr_in));

    ldr r1, =FD_SERVER_OFFSET
    neg r1, r1
    ldr r0, [r11, r1]           @     mov edi, [rbp - FD_SERVER_OFFSET]
    eor r1, r1                  @     xor rsi, rsi
    eor r2, r2                  @     xor rdx, rdx
    bl accept                   @     call accept                                         ; fd_server_accepted = accept(fd_server, NULL, NULL);
    ldr r1, =FD_SERVER_ACCEPTED_OFFSET
    neg r1, r1
    str r0, [r11, r1]           @     mov [rbp - FD_SERVER_ACCEPTED_OFFSET], eax

                                @     ; /* send and receive */
    ldr r0, =PROMPT             @     mov rdi, PROMPT
    bl printf                   @     call printf                                         ; printf("Type message to send (max. 15 chars): ");

    ldr r0, =SCANF_FORMAT       @     mov rdi, SCANF_FORMAT
    ldr r1, =SEND_BUF_OFFSET
    sub r1, r11, r1             @     lea rsi, [rbp - SEND_BUF_OFFSET]
    bl scanf                    @     call scanf                                          ; scanf("%s", msg_buf);

    ldr r0, =SEND_FORMAT        @     mov rdi, SEND_FORMAT
    ldr r1, =SEND_BUF_OFFSET
    sub r1, r11, r1             @     lea rsi, [rbp - SEND_BUF_OFFSET]
    bl printf                   @     call printf                                         ; printf("Sending %s\n", msg_buf);

    ldr r1, =FD_CLIENT_OFFSET
    neg r1, r1
    ldr r0, [r11, r1]           @     mov edi, [rbp - FD_CLIENT_OFFSET]
    ldr r1, =SEND_BUF_OFFSET
    sub r1, r11, r1             @     lea rsi, [rbp - SEND_BUF_OFFSET]
    ldr r2, =SEND_BUF_SIZE      @     mov rdx, SEND_BUF_SIZE
    eor r3, r3                  @     xor rcx, rcx
    bl send                     @     call send                                           ; send(fd_client, msg_buf, sizeof(msg_buf), 0);

    ldr r1, =FD_SERVER_ACCEPTED_OFFSET
    neg r1, r1
    ldr r0, [r11, r1]           @     mov edi, [rbp - FD_SERVER_ACCEPTED_OFFSET]
    ldr r1, =RECV_BUF_OFFSET
    sub r1, r11, r1             @     lea rsi, [rbp - RECV_BUF_OFFSET]
    ldr r2, =RECV_BUF_SIZE      @     mov rdx, RECV_BUF_SIZE
    bl recv                     @     call recv                                           ; recv(fd_server_accepted, msg_buf, sizeof(msg_buf), 0);

    ldr r0, =RECV_FORMAT        @     mov rdi, RECV_FORMAT
    ldr r1, =RECV_BUF_OFFSET
    sub r1, r11, r1             @     lea rsi, [rbp - RECV_BUF_OFFSET]
    bl printf                   @     call printf                                         ; printf("Received %s\n", msg_buf);

                                @     ; /* clean up */
                                @     xor rdi, rdi
    ldr r1, =FD_SERVER_ACCEPTED_OFFSET
    neg r1, r1
    ldr r0, [r11, r1]           @     mov edi, [rbp - FD_SERVER_ACCEPTED_OFFSET]
    bl close                    @     call close                                          ; close(fd_server_accepted);
    ldr r1, =FD_CLIENT_OFFSET
    neg r1, r1
    ldr r0, [r11, r1]           @     mov edi, [rbp - FD_CLIENT_OFFSET]
    bl close                    @     call close                                          ; close(fd_client);
    ldr r1, =FD_SERVER_OFFSET
    neg r1, r1
    ldr r0, [r11, r1]           @     mov edi, [rbp - FD_SERVER_OFFSET]
    bl close                    @     call close                                          ; close(fd_server);

.done:
    mov sp, r11
    pop {r11, pc}               @     pop rbx
                                @     mov rsp, rbp
                                @     pop rbp
    eor r0, r0                  @     xor rax, rax
    bx lr                       @     ret ; main                                          ;}
