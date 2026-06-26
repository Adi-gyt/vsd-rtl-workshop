AUTHOR:
ADITH RAJ
Student BTech In Electrical And Communication.

# vsdRiscvSoc - week 1
# India RISC-V Chip Tapeout – Project-Based Learning
This repository documents my journey through the India RISC-V Chip Tapeout    project-based learning program. The project focuses on setting up and using the  RISC-V Toolchain in a Linux environment, learning about chip design basics, and completing tasks that simulate a hands-on industry-level experience.

Lab Setup Requirements
To begin this project, I followed these steps to set up the required environment:

1. Operating System: Used Oracle VirtualBox to set up a Linux environment.
2. ## ✅ RISC-V GCC Toolchain Setup on Windows (xPack)
```bash
Toolchain:   xPack RISC-V Embedded GCC  
Architecture: riscv32 (supports rv32imac)  
Host OS:     Windows 10/11 (64-bit)
```
## 📥 Installation Steps

### 🔽 Download the Toolchain

Download the Windows 64-bit version of the xPack RISC-V GCC from the official site:  
👉 [xPack RISC-V GCC Releases](https://xpack.github.io/riscv-none-elf-gcc/)
```css
xpack-riscv-none-elf-gcc-12.2.0-1.2-win64.zip
## 🔧 Set Environment Variables
```
Add the `bin` folder inside the toolchain directory to your system `PATH`:

### 🧭 Steps:

1. Open **System Properties** → **Environment Variables**
2. Under **System variables**, find and select the `Path` variable → click **Edit**
3. Click **New** and add the following path:

```makefile
C:\riscv-toolchain\bin
## ✅ Verify Installation
```
After setting up the environment variables, verify the toolchain installation.

### 🔍 Check Toolchain Version

Open `cmd.exe` or `PowerShell`, and run:

```sh
riscv-none-elf-gcc --version
```
Expected Output
![Screenshot 2025-06-08 172121](https://github.com/user-attachments/assets/30b6590c-c09f-46f2-abed-ce5fab5553c4)

```sh
riscv-none-elf-gcc (xPack GNU RISC-V Embedded GCC) 12.2.0
```
Verified that the tool is available in the system path:
```
```sh
where riscv-none-elf-gcc
```

Checked compilation using a sample test program:
```sh
riscv-none-elf-gcc -march=rv32imac -mabi=ilp32 -Wall -ffreestanding -O0 -c hello.c -o hello.o
riscv-none-elf-ld -T linker.ld hello.o -o hello.elf
```
# ✅ Task 2: Compile “Hello, RISC-V”
## 📝 Task Description
The objective of this task was to write a minimal C program that prints `"Hello, RISC-V"` and cross-compile it using the **RISC-V GCC toolchain** targeting the `rv32imc` architecture. The goal was to produce a valid RISC-V ELF executable and verify the architecture and format.
### 📄 Create a Minimal C Program
Create hello.c using a text editor (e.g., nano):
```bash
nano hello.c
```
```c
#include <stdio.h>

int main() {
    printf("Hello, RISC-V\n");
    return 0;
}
```
🛠️ Cross-Compiled with RISC-V GCC
Run this command to cross-compile:

```bash
riscv32-unknown-elf-gcc -march=rv32imc -mabi=ilp32 -o hello.elf hello.c
```
Flags:

-march=rv32imc: Target architecture (RV32IMC = Base + Multiply + Compressed).

-mabi=ilp32: Application Binary Interface (32-bit integers, longs, pointers).

-o hello.elf: Output filename.

I compiled the program using the following command:

✅ This produced an ELF binary named hello.elf.

📦 Verified the ELF Output
To verify the compiled file format, I used:

```bash
file hello.elf
```
 Verify the ELF File
Check the file type:

```bash
file hello.elf
```
Expected Output:

```
hello.elf: ELF 32-bit LSB executable, UCB RISC-V, version 1 (SYSV), statically linked, not stripped
```
To see the output:

```bash
qemu-system-riscv32 -nographic -machine virt -kernel hello.elf
```
Expected Output:

plaintext
Hello, RISC-V!

📌 Output:![hello](https://github.com/user-attachments/assets/2652b7ff-964a-4d39-b5d3-82a36e71dc56)


📚 What I Learned
Gained hands-on experience compiling a C program using the riscv32-unknown-elf-gcc toolchain.

Learned the significance of:

-march=rv32imc — targets the RV32 ISA with Integer, Multiplication, and Compressed instructions.

-mabi=ilp32 — sets the Integer calling convention and memory layout.

Understood the basics of ELF file formats and used the file command to inspect compiled binaries.

# ✅ Task 3: From C to Assembly

## 📝 Task Description
The objective of this task was to convert the `hello.c` program into RISC-V assembly using the RISC-V GCC toolchain, and analyze the resulting assembly code to understand how basic C constructs are translated for the `rv32imc` architecture.

## ⚙️ What I Did

### 🧾 Compiled C to Assembly

Used the following command to generate assembly from `hello.c`:

```bash
riscv64-unknown-elf-gcc -march=rv32imc -mabi=ilp32 -S -O0 hello.c
```
✅ This generated an assembly file: hello.s

🔧 Function Prologue
The beginning of the main function sets up the stack and frame pointer:

```assembly
addi sp, sp, -16     # Allocate stack space
sw   s0, 12(sp)      # Save s0 (callee-saved register)
addi s0, sp, 16      # Establish frame pointer
```
The characters are printed using memory-mapped I/O (e.g., UART). Instructions include:

*lui + lw: Load UART base address

*li: Load character ASCII values

*sw: Send characters to UART

This mimics printing functionality in a bare-metal environment without an OS.

🌀 Program Termination (Infinite Loop)
At the end of the program:

```assembly
.L2:
    j .L2
```
✅ This is an intentional infinite loop to prevent return, as there’s no operating system to return to in a bare-metal environment.

![Task 3](https://github.com/user-attachments/assets/a5e5f2da-d0b6-4b65-998b-097da2f2a5d2)
![task3 2](https://github.com/user-attachments/assets/64596fac-8b6e-4b1b-9417-89aaf52a2230)


📚 What I Learned
Learned how to use the -S flag with GCC to generate human-readable assembly.

Understood the basic structure of function prologues and epilogues in RISC-V.

Gained insight into how printf-like functionality is implemented in bare-metal by writing directly to memory-mapped I/O.

Realized why bare-metal code uses infinite loops to terminate programs safely.
# ✅ Task 4: Hex Dump & Disassembly

## 📝 Task Description
The objective of this task was to analyze the compiled ELF file (`hello.elf`) by:
- Generating a disassembly listing (to see memory addresses, opcodes, and mnemonics)
- Creating a hex dump in Intel HEX format to view the raw byte-level contents of the binary
## ⚙️ What I Did
### 🔍 Disassembled ELF File
Used the following command to disassemble `hello.elf`:
```bash
riscv64-unknown-elf-objdump -d hello.elf > hello.dump
```
✅ This produced hello.dump, which contains:
Instruction addresses
Machine (hex) code
RISC-V assembly mnemonics

📄 Example from hello.dump:
```
80400000: 1141       addi sp, sp, -16
```
Explanation:
* 80400000:          //Memory address of the instruction
* 1141:              //Raw machine code in hexadecimal
* addi sp, sp, -16:  //The actual RISC-V instruction

💾 Created Intel HEX Dump
To generate a hex-format file:

```bash
riscv64-unknown-elf-objcopy -O ihex hello.elf hello.hex
```
✅ This produced hello.hex, a text representation of the program’s binary content in Intel HEX format — useful for programming devices.
📂 Viewed Dump File Using less
```bash
less hello.dump
```
This allowed scrolling through the disassembly output inside the terminal.

📌 Typical view:
```
80400000 <_start>:
80400000: 1141       addi sp,sp,-16
80400002: c422       sw   s0,12(sp)
~
~
(END)
```
Note:
~ denotes unused lines (not part of file)
(END) means you're at the end of the output
Press q to quit the viewer

📃 Optional: View Without Scroll
```bash
cat hello.dump
```
This directly prints the full disassembly in the terminal without needing to scroll.
![Screenshot from 2025-06-06 18-19-53](https://github.com/user-attachments/assets/8666a552-d1f4-4e79-950c-64e0e91bd709)

![Screenshot from 2025-06-06 18-15-40](https://github.com/user-attachments/assets/b85154d6-5337-4c10-aa3b-7ddff68690d5)

📚 What I Learned
Learned how to use objdump -d to inspect RISC-V ELF binaries and understand memory layout, opcodes, and instruction mapping.

Understood how to read Intel HEX files using objcopy -O ihex, which is commonly used in embedded systems.
# ✅ Task 5: ABI & Register Cheat Sheet 

## 📝 Task Description

The objective of this task was to learn and document the 32 RISC-V general-purpose integer registers, understand their ABI (Application Binary Interface) names, and analyze their roles based on RISC-V calling conventions.

---

## 📋 Step 1: Register Table

| Register | ABI Name | Description           | Role (Calling Convention)  |
|----------|----------|-----------------------|-----------------------------|
| x0       | zero     | Hard-wired 0          | Constant 0                  |
| x1       | ra       | Return address        | Caller-saved                |
| x2       | sp       | Stack pointer         | Callee-saved                |
| x3       | gp       | Global pointer        | —                           |
| x4       | tp       | Thread pointer        | —                           |
| x5       | t0       | Temporary             | Caller-saved                |
| x6       | t1       | Temporary             | Caller-saved                |
| x7       | t2       | Temporary             | Caller-saved                |
| x8       | s0/fp    | Saved / Frame Pointer | Callee-saved                |
| x9       | s1       | Saved                 | Callee-saved                |
| x10      | a0       | Arg 1 / return value  | Caller-saved                |
| x11      | a1       | Arg 2 / return value  | Caller-saved                |
| x12      | a2       | Arg 3                 | Caller-saved                |
| x13      | a3       | Arg 4                 | Caller-saved                |
| x14      | a4       | Arg 5                 | Caller-saved                |
| x15      | a5       | Arg 6                 | Caller-saved                |
| x16      | a6       | Arg 7                 | Caller-saved                |
| x17      | a7       | Arg 8                 | Caller-saved                |
| x18      | s2       | Saved                 | Callee-saved                |
| x19      | s3       | Saved                 | Callee-saved                |
| x20      | s4       | Saved                 | Callee-saved                |
| x21      | s5       | Saved                 | Callee-saved                |
| x22      | s6       | Saved                 | Callee-saved                |
| x23      | s7       | Saved                 | Callee-saved                |
| x24      | s8       | Saved                 | Callee-saved                |
| x25      | s9       | Saved                 | Callee-saved                |
| x26      | s10      | Saved                 | Callee-saved                |
| x27      | s11      | Saved                 | Callee-saved                |
| x28      | t3       | Temporary             | Caller-saved                |
| x29      | t4       | Temporary             | Caller-saved                |
| x30      | t5       | Temporary             | Caller-saved                |
| x31      | t6       | Temporary             | Caller-saved                |

---

## 📌 Step 2: Calling Convention Summary

### 🔹 a0–a7 (x10–x17)
- **Purpose**: Function arguments and return values
- **Convention**: Caller-saved

### 🔹 s0–s11 (x8–x9, x18–x27)
- **Purpose**: Saved registers (used for variables that persist across function calls)
- **Convention**: Callee-saved

### 🔹 t0–t6 (x5–x7, x28–x31)
- **Purpose**: Temporaries
- **Convention**: Caller-saved (can be used freely without saving)

### 🔹 Special Registers
- **ra (x1)**: Return address
- **sp (x2)**: Stack pointer
- **fp (alias of s0)**: Frame pointer


## 📚 What I Learned

- RISC-V uses **32 general-purpose registers (x0–x31)**.
- Each has an **ABI name** and a specific role in the **calling convention**.
- Learned the difference between:
  - **Caller-saved registers**: Must be saved by the caller if needed.
  - **Callee-saved registers**: Preserved across function calls by the called function.
- This understanding is essential for:
  - Writing and debugging assembly code
  - Understanding function call behavior
  - Managing memory and stack frames properly
# ✅ Task 6: Stepping with GDB 🧪

## 🎯 Task Goal

The objective of this task was to step through the RISC-V program execution using `riscv64-unknown-elf-gdb`, set breakpoints, inspect registers, and understand low-level control flow in a bare-metal environment.

---
### 🧩 1. Start GDB

```bash
riscv64-unknown-elf-gdb hello.elf
```
This launches GDB with the compiled ELF file.

🧩 2. Connect to Built-in Simulator
```(gdb)
target sim
```
This tells GDB to use its internal RISC-V simulator (no hardware or QEMU required).

🧩 3. Set a Breakpoint
```(gdb)
 break _start
```
This sets a breakpoint at the _start label (the program entry point).

You can also use any symbol present in hello.s.

🧩 4. Run the Program
```(gdb)
 run
```
Execution starts and halts at the specified breakpoint.

🧩 5. Step Through Instructions
```(gdb)
 stepi
```
Or simply:
```(gdb)
si
```
This steps through one machine instruction at a time.

Repeat to walk through the program’s execution.

🧩 6. Inspect Registers
```(gdb)
 info registers
```
![Screenshot from 2025-06-06 18-34-49](https://github.com/user-attachments/assets/8b304a65-59ab-4c98-a682-205265c5dbce)

To view specific registers:
```
(gdb) print $a0
(gdb) print $sp
(gdb) print $pc
```
This gives insight into data flow and instruction effects.

📘 What I Learned
How to launch and use riscv64-unknown-elf-gdb in a bare-metal setup.

How to interact with GDB’s internal simulator.

How to set and hit breakpoints at specific symbols (like _start).

How to step through instructions (stepi) and observe exact behavior.
## ✅ Task 7: Running Under an Emulator

### 🎯 Objective
Run a compiled RISC-V ELF program (`hello.elf`) using QEMU (or Spike) to simulate bare-metal execution and observe UART output.

🛠️ What I Did
🧾 Step 1: Wrote hello.c
```c
void main() {
    volatile char* uart = (char*)0x10000000;
    const char* msg = "Hello, RISC-V!\n";
    while (*msg) {
        *uart = *msg++;
    }
}
```
✅ This uses direct memory-mapped UART I/O instead of printf, avoiding standard library dependencies.

🧾 Step 2: Compiled for RISC-V 
```bash
riscv32-unknown-elf-gcc -march=rv32imc -mabi=ilp32 -nostdlib -ffreestanding \
  -Wl,-Ttext=0x80000000 -e main -o hello.elf hello.c
```
Flags used:

-nostdlib: No C library or startup files.

-ffreestanding: No assumptions about runtime environment.

-Ttext=0x80000000: Place program at specific memory address in RAM.

🧾 Step 3: Ran on QEMU
```bash
qemu-system-riscv32 -nographic -machine virt -bios none -kernel hello.elf

```
✅ Output observed in terminal:
```
Hello, RISC-V!
```
![Screenshot 2025-06-08 190323](https://github.com/user-attachments/assets/cb342cd9-6ec5-4231-96b5-2b42f9e6b3b9)

🔍 Why This Matters
📦 Embedded Programming: Bare-metal programming skills are essential for microcontroller and SoC development.

⚙️ Toolchain Mastery: Understanding how to compile, link, and run ELF files prepares you for real-world development on custom hardware.

🧠 Firmware Awareness: You now know when and why to include firmware like OpenSBI depending on your system needs.

How to monitor CPU state using info registers and print $<reg>.
# ✅ Task 8: Exploring GCC Optimization 🎯

## 📝 Goal

Understand the impact of compiler optimizations in GCC by comparing RISC-V assembly output of the same program compiled with and without optimizations.
## ⚙️ Steps Followed

### 🔧 1. Compiled Without Optimization (`-O0`)

```bash
riscv32-unknown-elf-gcc -S -O0 hello.c -o hello_O0.s
```
This version includes all instructions, comments, and intermediate steps.

Prioritizes readability and debugging over performance.

🚀 2. Compiled With Optimization (-O2)
```bash
riscv32-unknown-elf-gcc -S -O2 hello.c -o hello_O2.s
```
This version is optimized for speed and efficiency.

Removes unused code and simplifies instruction flow.

🔍 3. Compared the Files
```bash
diff hello_O0.s hello_O2.s
```
This command shows line-by-line differences between the two versions of the assembly code.
![Screenshot from 2025-06-06 18-45-26](https://github.com/user-attachments/assets/aea6318a-1dc3-4203-b478-8998f7c53c0e)
![Screenshot from 2025-06-06 18-45-45](https://github.com/user-attachments/assets/206e00f6-1b6c-408c-867a-c87eb46490c7)

📊 Observations from diff Output
Aspect	-O0 Version	-O2 Version
Instruction Count	More, includes setup & padding	Significantly fewer
Dead Code	Present	Removed
Register Usage	Conservative, more saved/restored	Efficient reuse
Function Call	Standard call to printf()	Often optimized or partially inlined
Prologue/Epilogue	Present	Simplified or skipped

📘 What I Learned
The -O2 optimization level performs dead code elimination, constant folding, loop unrolling, and more.

Optimized assembly is harder to read but far more efficient.

The compiler intelligently avoids storing values in memory unless necessary and reuses registers.

Observed noticeable reduction in stack operations and instructions in the -O2 version.

This demonstrates how compilers balance performance vs. clarity depending on optimization levels.
# ✅ Task 9: Inline Assembly – Reading the cycle CSR 🧠

## 🎯 Task Goal

Use RISC-V inline assembly to read the `cycle` CSR register and print the difference in CPU cycles between two code points using UART.

## 📄 Source: `task9_cycle.c`
```c
#include <stdint.h>

#define UART ((volatile char *)0x10000000)

static inline uint32_t rdcycle(void) {
    uint32_t c;
    asm volatile ("csrr %0, cycle" : "=r"(c));
    return c;
}

void print_hex(uint32_t val) {
    const char hex[] = "0123456789ABCDEF";
    for (int i = 7; i >= 0; i--) {
        UART[0] = hex[(val >> (i * 4)) & 0xF];
    }
    UART[0] = '\n';
}

void _start() {
    print_hex(0xDEADBEEF);  // UART check

    uint32_t before = rdcycle();
    for (volatile int i = 0; i < 100000; i++);
    uint32_t after = rdcycle();

    print_hex(after - before);

    while (1);  // Halt
}
```
🔧 link.ld
```ld

ENTRY(_start)

SECTIONS {
  . = 0x80400000;

  .text : { *(.text*) }
  .rodata : { *(.rodata*) }
  .data : { *(.data*) }
  .bss : {
    *(.bss*)
    *(COMMON)
  }
}
```
🛠️ Makefile
```make

CC = riscv64-unknown-elf-gcc
CFLAGS = -march=rv32imac_zicsr -mabi=ilp32 -nostartfiles -nostdlib -Wall

all: task9.elf

task9.elf: task9_cycle.c link.ld
	$(CC) $(CFLAGS) -o task9.elf task9_cycle.c -T link.ld

clean:
	rm -f task9.elf
```
▶️ How I Ran It
🧪 Steps:
```bash
make clean
make
qemu-system-riscv32 -nographic -machine virt \
  -bios /media/sf_firmware/fw_jump.bin \
  -kernel task9.elf
```
✅ Expected Output:
```
DEADBEEF
00003ACF
```
DEADBEEF confirms UART is printing correctly.

Second line shows the cycle difference between rdcycle() calls.

📘 What I Learned
Used inline assembly in C to access Control and Status Registers (CSRs).

Learned how asm volatile ("csrr %0, cycle" : "=r"(c)); works:

csrr reads the current cycle count.

%0 maps the result into a C variable (c).

volatile prevents reordering/removal by compiler.

Gained deeper understanding of bare-metal cycle timing.

Practiced hex printing to UART and basic benchmarking.
# ✅ Task 10: Memory-Mapped I/O – GPIO Toggle Demo
## 🎯 Task Goal
Access a memory-mapped GPIO register (`0x10012000`) and toggle its value to simulate turning an LED on and off in a bare-metal environment using C.
## 🧱 What is Memory-Mapped I/O?
Memory-mapped I/O allows software to control hardware by reading from or writing to specific memory addresses. In this case:
```c
#define GPIO (*(volatile uint32_t*)0x10012000)
```
This line creates a volatile pointer to a memory location mapped to GPIO. Using volatile ensures the compiler doesn't optimize away reads/writes to this register.

📄 Source Code: task10_gpio.c
```c
#include <stdint.h>

#define GPIO (*(volatile uint32_t*)0x10012000)

void _start() {
    GPIO = 0x1;  // Turn ON (e.g., LED ON or pin HIGH)

    for (volatile int i = 0; i < 100000; i++);  // Simple delay loop

    GPIO = 0x0;  // Turn OFF (e.g., LED OFF or pin LOW)

    while (1);  // Halt the CPU
}
```
📄 Linker Script: link.ld
```ld
ENTRY(_start)

SECTIONS {
  . = 0x80200000;

  .text : { *(.text.entry) *(.text*) }
  .data : { *(.data*) }
  .bss  : { *(.bss*) *(COMMON) }
}
```
🛠️ Compilation
```bash
riscv32-unknown-elf-gcc -march=rv32imac -mabi=ilp32 -nostartfiles -T link.ld \
  -o task10_gpio.elf task10_gpio.c
```
▶️ Running the Program
```bash
qemu-system-riscv32 -nographic -machine virt \
  -bios /media/sf_firmware/fw_jump.bin \
  -kernel task10_gpio.elf
```
✅ Expected Result
There’s no UART output, but QEMU should keep running silently.

No crash or segmentation fault means the program executed successfully.

On real hardware or with GDB, you could inspect address 0x10012000 to confirm the writes.

📘 What I Learned
How to directly access and manipulate hardware using memory-mapped I/O in a RISC-V bare-metal setup.

How to set up a custom linker script to control memory layout.

Why volatile is essential for accessing peripheral registers.

Practiced writing minimal C startup code without main() or an operating system.
# ✅ Task 11: Linker Script 101 – Placing Code and Data in Custom Memory Regions
## 🎯 Objective

Create a custom linker script that:
- Places `.text` (code) section at address `0x00000000` (Flash)
- Places `.data` section at address `0x10000000` (RAM)

This mirrors a typical embedded system layout: **Flash for instructions, RAM for data**.

## 🧱 Step 1: Linker Script – `task11.ld`

```ld
ENTRY(_start)

SECTIONS {
  /* Code goes into Flash (0x00000000) */
  . = 0x00000000;

  .text : {
    *(.text.entry)
    *(.text*)
  }

  /* Data goes into RAM (0x10000000) */
  .data : {
    . = 0x10000000;
    *(.data*)
  }

  /* Uninitialized data (BSS) also goes into RAM */
  .bss : {
    *(.bss*)
    *(COMMON)
  }
}
```
📄 Step 2: Test Program – task11_test.c
```c

#include <stdint.h>

volatile int my_data = 42;

void _start() {
    my_data = 99;
    while (1);  // Halt
}
my_data resides in the .data section.

_start() modifies it, ensuring it’s treated as a live variable in RAM.
```
🛠️ Step 3: Compilation
```bash
riscv32-unknown-elf-gcc -nostartfiles -T task11.ld \
  -o task11.elf task11_test.c
```
🧪 Step 4: Inspect Section Placement
```bash
riscv32-unknown-elf-objdump -h task11.elf
```
✅ Example Output:

```
Idx Name      Size     VMA          LMA          File off  Algn
 0 .text      000000XX 00000000     00000000     ...
 1 .data      00000004 10000000     10000000     ...
```
![task11](https://github.com/user-attachments/assets/c65e349b-34c6-4862-adfd-cf8a65102156)

.text placed at 0x00000000 ✅

.data placed at 0x10000000 ✅

This confirms the linker script correctly assigned sections.

📘 What I Learned
How to manually control section placement using a linker script.

The difference between Flash (code storage) and RAM (data storage) in embedded systems.

How to use objdump to verify memory layouts of compiled binaries.

Practical experience building a bare-metal memory map for RISC-V.
# ✅ Task 12: Start-up Code & crt0 – Simulating Low-Level Boot
## 🎯 Objective

Understand the responsibilities of `crt0.S` (C RunTime zero) in embedded RISC-V programs and how to simulate its behavior with a manual `_start()` in C.

## 🧠 What crt0.S Typically Does

In most bare-metal programs, `crt0.S` is the **first assembly code that runs** before `main()` or `_start()` in C.

Its responsibilities:

- 🪜 Set up the **stack pointer (`sp`)**
- 🧹 Zero out the **`.bss` section** (uninitialized data)
- 🧾 Copy `.data` section from **Flash to RAM** (if needed)
- 🧰 Run global constructors (for C++)
- 🚀 Call `main()` or user-defined `_start()`
- 🔁 Loop forever or call `exit()`

## 💡 What I Did in This Task

I simulated the behavior of crt0.S by writing a manual _start() in C, which ran without error under QEMU. Since the program ran as expected and didn't require .bss or .data relocation, this successfully mimics a basic crt0 setup.
```c
void _start() {
    // Stack initialization skipped (QEMU handles it)
    setup_interrupts();  // Example of setup code

    while (1) {
        if (triggered) {
            count++;
            triggered = 0;
        }
    }
}
```
✅ Stack setup was skipped since QEMU auto-sets sp.

✅ No need to clear .bss or relocate .data in this minimal example.

✅ This serves as a working substitute for crt0.

📘 What I Learned
The role of crt0.S as the bare-metal boot entry point.

Its responsibility in preparing memory and calling into C code.

That a minimal _start() in C can substitute crt0.S under QEMU, for educational/testing purposes.

Understanding this flow is critical for writing bootloaders, OS kernels, or initializing microcontrollers.
## ✅ Task 13: Interrupt Primer (RISC-V Bare-Metal)

### 🎯 Objective
Enable the machine-timer interrupt (MTIP) and write a simple handler in C for a bare-metal RISC-V system.

### 🧩 Concept Overview

This task demonstrates how to:
- Use the RISC-V **machine timer (mtime / mtimecmp)** to generate interrupts.
- Write an **interrupt handler** in C using `__attribute__((interrupt))`.
- Use **memory-mapped I/O** to simulate UART output.
- Work with **CSRs (Control and Status Registers)** for enabling interrupts.

### 🧠 Key Concepts Learned

#### ✅ Timer Interrupts
- The **mtime** register keeps incrementing.
- When **mtime ≥ mtimecmp**, the **MTIP** bit triggers an interrupt.

#### ✅ Interrupt Handling
- Wrote a C handler for the timer interrupt:
```c
void __attribute__((interrupt)) timer_handler() {
    volatile uint32_t *uart = (uint32_t*)0x10000000;
    *uart = 'I';
    *(volatile uint64_t*)MTIMECMP += 100000;
}
```
✅ CSRs Used
mie → Enables machine-level interrupts (MTIE bit).

mstatus → Enables global interrupts (MIE bit).

✅ Memory-Mapped I/O
UART at address 0x10000000 is used to output characters to the terminal (QEMU simulation).

🛠️ Code and Compilation
🔹 interrupt.c
```c

#include <stdint.h>

#define MTIME       0x200BFF8
#define MTIMECMP    0x2004000

void __attribute__((interrupt)) timer_handler() {
    volatile uint32_t *uart = (uint32_t*)0x10000000;
    *uart = 'I';
    *(volatile uint64_t*)MTIMECMP += 100000;
}

void _start() {
    volatile uint32_t *uart = (uint32_t*)0x10000000;
    *uart = 'S';

    *(volatile uint64_t*)MTIMECMP = *(volatile uint64_t*)MTIME + 100000;

    asm volatile (
        "li t0, 0x88\n"       // MIE_MTIE (0x80) + MSTATUS_MIE (0x8)
        "csrs mie, t0\n"
        "csrs mstatus, t0\n"
    );

    while(1);
}
```
🔹 Compile
```bash
riscv32-unknown-elf-gcc -march=rv32imc_zicsr -mabi=ilp32 -nostdlib -ffreestanding \
  -Wl,-Ttext=0x80000000 -e _start -o interrupt.elf interrupt.c
-march=rv32imc_zicsr: Enables CSR access
-nostdlib: No libc or startup files
-ffreestanding: We’re not assuming a standard environment
```
▶️ Run in QEMU
```bash
qemu-system-riscv32 -nographic -machine virt -bios none -kernel interrupt.elf
```
🧪 Expected Output
```
SIIIIIIIIIIIIIIIIIIII...
```
S → Printed at startup

I → Printed periodically by timer interrupt
![Screenshot 2025-06-08 181642](https://github.com/user-attachments/assets/62062a4f-3ed7-429c-b207-4dc840008e75)

✅ Why This Matters
Interrupts are essential for real-time response in embedded systems.

Bare-metal timer configuration and interrupt handling are foundational for OS development.

Reinforced working with CSRs, memory-mapped I/O, and toolchain flags.
## ✅ Task 14: `rv32imac` vs `rv32imc` — What’s the “A”?

### 🎯 Objective
Understand the role of the ‘A’ (Atomic) extension in the RISC-V instruction set and its difference from `rv32imc`.

---

### 🧠 What Does `rv32imac` Mean?

- `rv32` → 32-bit RISC-V architecture  
- `i` → Integer instructions  
- `m` → Multiply/Divide instructions  
- `a` → **Atomic instructions** ✅  
- `c` → Compressed instructions (16-bit format)

So:
- `rv32imac` includes **atomic operations**
- `rv32imc` does **not** include atomic instructions

---

### 🔑 What Does the “A” Extension Add?

The Atomic (A) extension adds **atomic memory operations** essential for:

- Multithreading / concurrency
- Locking mechanisms (spinlocks, mutexes)
- Operating systems and kernel code
- Shared memory programming

---

### 🔨 Key Instructions from “A” Extension

| Instruction | Description                   |
|-------------|-------------------------------|
| `lr.w`      | Load-Reserved (word)          |
| `sc.w`      | Store-Conditional (word)      |
| `amoswap.w` | Atomic Swap                   |
| `amoadd.w`  | Atomic Add                    |
| `amoor.w`   | Atomic OR                     |
| `amoand.w`  | Atomic AND                    |

---

### 📌 Example: Spinlock with `lr.w` and `sc.w`

```c
volatile int lock = 0;

void lock_acquire() {
    int tmp;
    do {
        asm volatile (
            "lr.w %0, (%1)\n"
            "sc.w %0, %2, (%1)\n"
            : "=&r"(tmp)
            : "r"(&lock), "r"(1)
            : "memory"
        );
    } while (tmp);  // Loop until store succeeds
}

```
![Screenshot from 2025-06-07 00-45-28](https://github.com/user-attachments/assets/c2b8f9f5-0bb1-4aef-b3fa-b2de05bd759e)

##Important Points

rv32imac includes atomic memory instructions, making it ideal for multithreaded and OS-level development.

rv32imc lacks these, so it’s better suited for simple bare-metal systems.

Atomic instructions allow safe concurrent access to shared memory.
## ✅ Task 15: Atomic Test Program (Using `lr.w` and `sc.w`)
### 🎯 Objective
Use atomic RISC-V instructions (`lr.w` and `sc.w`) to safely increment a shared variable using a spinlock.
### 🧾 Step-by-Step Execution

#### 📝 Step 1: Code – `atomic.c`
```c
volatile int lock = 0;
volatile int shared_counter = 0;

void acquire_lock() {
    int tmp;
    do {
        asm volatile (
            "lr.w %0, (%1)\n"
            "sc.w %0, %2, (%1)\n"
            : "=&r"(tmp)
            : "r"(&lock), "r"(1)
            : "memory");
    } while (tmp);
}

void release_lock() {
    lock = 0;
}

void _start() {
    for (int i = 0; i < 5; i++) {
        acquire_lock();
        shared_counter++;
        release_lock();
    }
    while (1);
}
```
✅ This code demonstrates a mutex-style spinlock using RISC-V’s atomic lr.w (load-reserved) and sc.w (store-conditional).

🔧 Step 2: Linker Script
Ensure the linker script (e.g., link.ld) sets the load address to something like 0x80200000, consistent with OpenSBI expectations.

🧪 Step 3: Compile
```
bash
riscv64-unknown-elf-gcc -nostartfiles -nostdlib -march=rv32imac -mabi=ilp32 \
  -T link.ld -o task15.elf atomic.c syscalls.c
```
-nostdlib -nostartfiles: Bare-metal compilation
syscalls.c: Custom stub for environment needs (minimal, empty versions acceptable)

▶️ Step 4: Run in QEMU
```bash
qemu-system-riscv32 -nographic -machine virt \
  -bios /media/sf_firmware/fw_jump.bin \
  -kernel task15.elf \
  -s -S
```
-s -S: Waits for debugger connection (port 1234)

🐞 Step 5: Inspect in GDB
In a second terminal:

```bash
riscv64-unknown-elf-gdb task15.elf
(gdb) target remote :1234
(gdb) break _start
(gdb) continue
(gdb) print shared_counter
```
✅ Expected Output:

```gdb
$1 = 5
```
This confirms the shared counter incremented atomically in a safe region guarded by acquire_lock() and release_lock().
![Screenshot 2025-06-08 193935](https://github.com/user-attachments/assets/689ff692-f28c-42b5-add8-2a35674a1002)

📚 What I Learned
Atomic Instructions:

lr.w: Performs a load and reserves the memory address

sc.w: Stores only if the reservation is still valid

Together, they form a lock-free synchronization primitive

Spinlocks: Used lr.w/sc.w loop to ensure mutual exclusion

Bare-Metal Debugging:

Ran and paused execution in QEMU with -s -S

Used GDB to inspect memory/registers

🧠 Why This Matters
⚙️ Multithreading and Concurrency:

Essential for writing OS kernels, real-time applications, and drivers

🔐 Synchronization:

Understanding atomic primitives helps implement critical sections

🔍 Debugging RISC-V Hardware Code:
## ✅ Task 16: printf() Without Standard Library (Bare-Metal RISC-V)
### 🎯 Objective
Use `printf()`-style functionality in a bare-metal RISC-V environment **without linking libc or stdio.h**, by implementing a custom `_write()` system call that outputs directly to UART.
### 🧾 Code Walkthrough
#### 🗂️ main.c
```c
extern int _write(int, const char*, int);  // Declare custom _write

int strlen(const char *s) {
    int len = 0;
    while (s[len] != '\0') len++;
    return len;
}

void print(const char *s) {
    _write(1, s, strlen(s));  // Write to UART
}

void _start() {
    print("Hello from RISC-V!\n");
    while (1);
}
```
🛠️ syscalls.c
```c
#include <stdint.h>

#define UART_TX (*(volatile uint32_t*)0x10000000)

int _write(int fd, const char *buf, int len) {
    for (int i = 0; i < len; i++) {
        UART_TX = buf[i];  // Direct memory-mapped I/O
    }
    return len;
}
```
⚙️ Compilation
```bash
riscv64-unknown-elf-gcc -Wall -O0 -ffreestanding -nostartfiles -nostdlib \
  -march=rv32imac -mabi=ilp32 -T link.ld \
  main.c syscalls.c -o task16.elf
```
✅ Flags used:

-nostdlib -nostartfiles: No standard startup code or libraries

-ffreestanding: For bare-metal programming

-T link.ld: Ensure correct load address

▶️ Execution in QEMU
```bash
qemu-system-riscv32 -nographic -machine virt \
  -bios /media/sf_firmware/fw_jump.bin \
  -kernel task16.elf \
  -serial file:uart.log
```
🔁 UART output redirected to uart.log

📤 Terminal Output
After execution, you can view the result with:

```bash
cat uart.log
```
Expected content:

```csharp
Hello from RISC-V!

```
![Screenshot from 2025-06-07 13-52-47](https://github.com/user-attachments/assets/d02c3dd6-5de3-472f-8a90-ae460e2a75f4)

🧠 What I Learned
✅ How printf() depends only on _write() under the hood

✅ Implemented a minimal print() function using only custom code

✅ Direct hardware I/O using memory-mapped UART
Task 17: Endianness Verification
Objective:
Verify how multi-byte values are stored in RISC-V memory to confirm the endianness.

Code Used:
A union of a 32-bit integer and 4 bytes was used to inspect the byte ordering of the number 0x12345678.

```c
union {
    uint32_t word;
    uint8_t bytes[4];
} u;

void _start() {
    u.word = 0x12345678;
    while (1);  // Halt here to inspect memory with GDB
}
```
Compilation Command:

```bash
riscv64-unknown-elf-gcc -Wall -g -nostartfiles -nostdlib -T link.ld \
  -msmall-data-limit=0 -march=rv32imac -mabi=ilp32 \
  endian.c -o task17.elf
```
Running and Debugging:
Run in QEMU with OpenSBI firmware and wait for GDB connection:

```bash
qemu-system-riscv32 -nographic -machine virt \
  -bios /media/sf_firmware/fw_jump.bin \
  -kernel task17.elf \
  -s -S
```
Connect GDB and inspect the union:

```gdb
(gdb) target remote :1234
(gdb) break _start
(gdb) continue
(gdb) print u.word
$1 = 305419896   # Decimal form of 0x12345678
(gdb) x/4bx &u
0x80200010: 0x78 0x56 0x34 0x12
```
![Screenshot from 2025-06-07 13-55-12](https://github.com/user-attachments/assets/1cc09c6b-688d-44c1-b331-02920c641fcc)

Result:
The bytes are stored in memory as 0x78 0x56 0x34 0x12, confirming that RISC-V uses little-endian format (least significant byte at the lowest memory address).

What I Learned:

How multi-byte values are stored in memory on RISC-V hardware.

RISC-V uses little-endian byte ordering.
✅ UART redirection in QEMU using -serial file:filename
