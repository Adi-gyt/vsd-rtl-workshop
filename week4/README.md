# Week 3 – Post-Synthesis GLS & Static Timing Analysis (STA)

### Overview  
Week 3 focused on validating the synthesized BabySoC design through **Gate-Level Simulation (GLS)** and understanding the fundamentals of **Static Timing Analysis (STA)** using **OpenSTA**.  
The goal was to confirm that the synthesized netlist behaves the same as the RTL design, verify timing correctness, and explore timing behavior across PVT corners.

---

### 🔹 Part 1 – Post-Synthesis GLS  
- Performed synthesis of the BabySoC design using **Yosys** → generated `vsdbabysoc_synth.v`.  
- Ran **Gate-Level Simulation (GLS)** on the synthesized netlist with **Icarus Verilog**.  
- Compared GLS output with RTL functional simulation (Week 2).  
- Observed matching results — both remained functionally equivalent after synthesis.  

**Deliverables:**  
`synth.log`, `vsdbabysoc_synth.v`, `gls_waveform.png`, short verification note.  

✅ **Result:** GLS = Functional Output

---

### 🔹 Part 2 – Static Timing Analysis (STA) Fundamentals  
- Studied how STA verifies timing without dynamic simulation.  
- Learned key terms: *arrival time*, *required time*, *slack*, and *critical paths*.  
- Understood setup/hold analysis, timing paths (reg-to-reg, in-to-out, etc.), and clock parameters.  
- Explored how tools like **OpenSTA** compute slack through graph-based and path-based analysis.  

✅ **Result:** Developed clear understanding of STA concepts and timing interpretation.

---

### 🔹 Part 3 – Static Timing Analysis with OpenSTA (PVT Sweep)  
- Installed and built **OpenSTA v2.7.0** with **CUDD 3.0.0**.  
- Prepared working directory with synthesized netlist, Sky130 liberty files, and SDC.  
- Ran STA for **TT corner** using `sky130_fd_sc_hd__tt_025C_1v80.lib`:
  - Critical Path: `_10009_ → _9855_` (FF-to-FF)  
  - Data Arrival: 9.25 ns, Required: 19.84 ns → Slack +10.59 ns (MET)
- Extended analysis across **FF**, **TT**, and **SS** corners using TCL automation (`sta_across_pvt.tcl`).  
- WNS / TNS reported 0.0000 for minimal SDC → expected for this setup.  

✅ **Result:** Successful OpenSTA runs across corners, timing pipeline verified.

---

### 🧠 Key Learnings  
- How to perform **GLS** and confirm synthesis correctness.  
- Fundamentals of **Static Timing Analysis** and interpreting WNS/TNS.  
- How to use **OpenSTA** with Sky130 libraries for timing verification.  
- Basics of **PVT corner** variation and its impact on timing.  
- Importance of clean netlists, valid SDCs, and reproducible tool flows.  

---
**Author:** Adith Raj  
**Date:** October 2025  
**Project:** VSD SoC – Week 3
