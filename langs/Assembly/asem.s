.global _start
.intel_syntax noprefix

// syscall table for x86_64 kernel operations
    // https://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/
// build intermediate object
    // $ as asem.s -o asem.o
// use linker to build binary
    // $ gcc -o asem asem.o -nostdlib -static
// run the binary
    // $ ./asem
// check exit code
    // $ echo $?
// binary to hex
    // $ cat asem | xxd > asem.hex
// view hex
    // $ nvim -c 'set ft=xxd' asem.hex
_start:

    // sys_write
    //mov rax, 1  // syscall #
    //mov rdi, 1  // file descriptor: stdout
    //lea rsi, [hello_world]  // buffer to load
    //mov rdx, 14  // char-len of buffer
    //syscall

    // sys_exit
    //mov rax, 60  // syscall #
    //mov rdi, 0  // exit code
    //syscall

    // sys_write
    mov rax, 1
    mov rdi, 1
    lea rsi, [hello_world]
    mov rdx, 14
    syscall

    // sys_exit
    mov rax, 60
    mov rdi, 0
    syscall

hello_world:
     .asciz "Hello, World!\n"
