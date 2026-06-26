# VSD RTL Design & Synthesis Workshop

A structured log of my work through the **VSD RTL Design and Synthesis Workshop**, covering the full digital design flow from RISC-V bare-metal programming through RTL synthesis, STA, and physical implementation.

**Author:** Adith Raj — B.Tech ECE, Sahrdaya College of Engineering and Technology  
**Program:** India RISC-V Chip Tapeout (Project-Based Learning)  
**PDK:** SkyWater 130 nm (`sky130_fd_sc_hd`)

---

## Tools Used

| Tool | Purpose |
|------|---------|
| Icarus Verilog (`iverilog`) | RTL and gate-level simulation |
| GTKWave | Waveform visualization |
| Yosys | Logic synthesis |
| Ngspice | SPICE-level circuit simulation |
| OpenSTA | Static Timing Analysis |
| OpenROAD | Physical implementation (floorplan, placement) |
| KLayout | Layout visualization |
| QEMU (`qemu-system-riscv32`) | RISC-V bare-metal emulation |
| GDB (`riscv64-unknown-elf-gdb`) | Assembly-level debugging |
| xPack RISC-V GCC | Cross-compilation toolchain |

---

## Repository Structure

```
vsd-rtl-workshop/
├── week1/   # RISC-V bare-metal programming (17 tasks)
├── week2/   # BabySoC functional simulation
├── week3/   # Post-synthesis GLS & OpenSTA
├── week4/   # CMOS circuit design with Sky130 + Ngspice
├── week5/   # OpenROAD floorplan & placement
└── week6/   # (ongoing)
```

Each week folder contains RTL/C source files, testbenches, simulation logs, synthesis reports, waveform screenshots, and a short README with run instructions.

---

## Week-by-Week Summary

### Week 1 — RISC-V Bare-Metal Programming (17 Tasks)

Set up the RISC-V GCC toolchain (xPack) on Windows and completed 17 hands-on tasks covering:

- Toolchain setup, compilation flags (`-march=rv32imc`, `-mabi=ilp32`), and ELF verification
- C → Assembly (`-S` flag), disassembly with `objdump`, Intel HEX with `objcopy`
- RISC-V ABI register table (x0–x31, caller/callee conventions)
- Stepping through instructions with GDB (`target sim`, `stepi`, `info registers`)
- Bare-metal UART output via QEMU (`qemu-system-riscv32 -machine virt`)
- GCC optimization comparison (`-O0` vs `-O2`, `diff` on assembly output)
- Inline assembly for CSR access (`csrr %0, cycle` — cycle counter benchmarking)
- Memory-mapped I/O: GPIO toggle at `0x10012000`
- Custom linker scripts: `.text` at Flash (`0x00000000`), `.data` at RAM (`0x10000000`)
- `crt0` startup code responsibilities (stack init, BSS zeroing, `.data` relocation)
- Machine-timer interrupt (`mtime`/`mtimecmp`, `mstatus`/`mie` CSRs, `__attribute__((interrupt))`)
- `rv32imac` vs `rv32imc` — the Atomic (A) extension and spinlock implementation with `lr.w`/`sc.w`
- Bare-metal `printf()` via custom `_write()` syscall stub
- Endianness verification using a `union` + GDB memory inspection (`x/4bx`) — confirmed little-endian

---

### Week 2 — BabySoC Functional Simulation

Worked with **BabySoC** — a minimal RISC-V SoC integrating RVMYTH CPU, a 10-bit DAC, and a PLL.

- Compiled and simulated the full SoC using `iverilog` + `vvp`
- Key files: `vsdbabysoc.v`, `rvmyth_avsddac_stripped.v`, `avsddac.v`, `avsdpll.v`, `testbench.v`
- Added `$dumpfile`/`$dumpvars` to testbench for VCD generation
- Observed in GTKWave: `clk`, `reset`, `RV_TO_DAC_bits[9:0]`, `OUT`
- Verified CPU → DAC integration: digital codes from the CPU producing correct DAC output transitions
- Understood why functional simulation matters before synthesis — early bug detection, fast iteration

---

### Week 3 — Post-Synthesis GLS & Static Timing Analysis

Validated the synthesized BabySoC netlist and ran STA with OpenSTA.

**GLS:**
- Synthesized BabySoC with Yosys → `vsdbabysoc_synth.v`
- Ran Gate-Level Simulation and confirmed functional equivalence with RTL sim output

**STA with OpenSTA:**
- Built OpenSTA v2.7.0 with CUDD 3.0.0
- Ran analysis using `sky130_fd_sc_hd__tt_025C_1v80.lib`
- Critical path: `_10009_ → _9855_` (FF-to-FF), Data Arrival: 9.25 ns, Slack: +10.59 ns ✅
- Extended across FF/TT/SS corners using a TCL automation script (`sta_across_pvt.tcl`)
- Key concepts: arrival time, required time, slack, setup/hold, WNS/TNS, PVT corners

---

### Week 4 — CMOS Circuit Design (Sky130 + Ngspice)

Six Ngspice simulations on a Sky130 CMOS inverter at the transistor level.

| Task | Focus | Key Result |
|------|-------|-----------|
| 1 | Id–Vds (NMOS) | Linear vs saturation regions; Vth ≈ 0.7 V, Id(max) ≈ 350 µA |
| 2 | Id–Vgs threshold extraction | Vth ≈ 0.7 V; sharp turn-on confirmed |
| 3 | CMOS Inverter VTC | VOH = 1.8 V, VOL ≈ 0 V, Vm ≈ 0.95 V ≈ VDD/2 |
| 4 | Transient delays | tPHL ≈ 0.8 ns, tPLH ≈ 0.9 ns (NMOS faster: µn > µp) |
| 5 | Noise margin analysis | NML ≈ 0.77 V, NMH ≈ 0.81 V — >40% VDD noise immunity |
| 6 | VDD & sizing variation | Higher VDD → wider swing; PMOS/NMOS sizing shifts Vm |

---

### Week 5 — OpenROAD Flow: Floorplan & Placement

Transitioned from logic-level design to physical backend using OpenROAD.

- Cloned and built OpenROAD Flow Scripts locally in a Linux/Ubuntu environment
- Ran the standard flow on the `gcd` design with Sky130 HD PDK: `make DESIGN_CONFIG=./designs/sky130hd/gcd/config.mk`
- Verified the generated floorplan (die/core area) and standard-cell placement in KLayout
- Observed `req_msg`/`resp_msg` nets confirming correct placement

---

## Running the Simulations

### Week 1 — RISC-V bare-metal (example: Task 7)
```bash
riscv32-unknown-elf-gcc -march=rv32imc -mabi=ilp32 -nostdlib -ffreestanding \
  -Wl,-Ttext=0x80000000 -e main -o hello.elf hello.c
qemu-system-riscv32 -nographic -machine virt -bios none -kernel hello.elf
```

### Week 2 — BabySoC simulation
```bash
iverilog -I src/include -o build/pre_synth_sim.out \
  src/module/testbench.v src/module/vsdbabysoc.v \
  src/module/rvmyth_avsddac_stripped.v src/module/avsddac.v src/module/avsdpll.v
vvp build/pre_synth_sim.out
gtkwave pre_synth_sim.vcd &
```

### Week 3 — OpenSTA
```bash
opensta
read_liberty sky130_fd_sc_hd__tt_025C_1v80.lib
read_verilog vsdbabysoc_synth.v
link_design vsdbabysoc
read_sdc constraints.sdc
report_checks
```

### Week 4 — Ngspice
```bash
ngspice task3_vtc.sp
```

### Week 5 — OpenROAD
```bash
cd OpenROAD-flow-scripts/flow
make DESIGN_CONFIG=./designs/sky130hd/gcd/config.mk
```

---

## Key Concepts Covered

- RISC-V ISA extensions: `rv32i`, `rv32im`, `rv32imc`, `rv32imac` (Atomic)
- ELF binaries, linker scripts, memory-mapped I/O, bare-metal startup
- ABI calling conventions, CSR access, machine-mode interrupts
- RTL simulation → synthesis → GLS → STA pipeline
- CMOS device physics: Vth, Id–Vds, VTC, noise margins, propagation delay
- Standard cell libraries, timing arcs, PVT corners
- Physical design: floorplanning, standard-cell placement, KLayout visualization

---

## References

- VSD-IAT Workshop Materials — Kunal Ghosh
- [SkyWater 130 nm PDK Documentation](https://skywater-pdk.readthedocs.io/)
- [OpenROAD Flow Scripts](https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts)
- [xPack RISC-V GCC](https://xpack.github.io/riscv-none-elf-gcc/)
- Ngspice User Manual v40+
