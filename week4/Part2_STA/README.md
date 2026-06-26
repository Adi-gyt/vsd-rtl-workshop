# Week 3 – Part 2 : Static Timing Analysis (STA) Fundamentals  

### Introduction  
This part focuses on understanding the principles behind **Static Timing Analysis (STA)** — a key step after synthesis used to ensure that a digital circuit meets its timing requirements.  
It explains how signal paths are analyzed, how delays and constraints are calculated, and how metrics like *arrival time*, *required time*, and *slack* determine whether a design meets timing at different corners.

---

### 1. Objective  
The goal of **Static Timing Analysis (STA)** is to verify if all signal paths in a design meet timing requirements without running dynamic simulations.  
STA checks the worst-case and best-case timing scenarios to ensure that data signals arrive neither too early nor too late relative to the clock.

---

### 2. Timing Path Basics  
In STA, every path in a circuit has a **start point** and an **end point**:

- **Start points:** Flip-flop clock pins or input ports  
- **End points:** Flip-flop D pins or output ports  

Each timing path includes:  
- A launch flip-flop (where data starts)  
- A combinational path (where logic delay occurs)  
- A capture flip-flop (where data is sampled)  

**Example:**  
A timing path from one flip-flop’s Q output to another’s D input is called a *reg-to-reg* path.

---

### 3. Arrival Time (AAT)  
The **arrival time** is the actual time a signal takes to propagate from the start point to the end point through gates and interconnects.  
It depends on:
- Gate delays  
- Wire delays  
- Input arrival times  

In timing graphs, arrival times are computed node by node by summing all delay contributions along the path.

---

### 4. Required Time (RAT)  
The **required time** is the expected or constraint-defined time by which the signal must arrive to satisfy the design’s timing requirements.  
It is derived from the system clock period and timing constraints.

**Example:**  
If the clock period is 3 ns and setup time is 0.2 ns, then data must arrive before 2.8 ns (3 − 0.2 ns).

---

### 5. Slack  
\[
\text{Slack} = \text{Required Time} - \text{Arrival Time}
\]

- **Positive Slack (+)** → Timing met  
- **Negative Slack (–)** → Timing violated  

**Types of slack:**  
- **Setup Slack (max slack):** Checks if data arrives too late.  
- **Hold Slack (min slack):** Checks if data arrives too early.  

**Examples:**  
- Required = 3 ns, Arrival = 3.5 ns → Slack = −0.5 ns (**setup violation**)  
- Required = 0.3 ns, Arrival = 0.2 ns → Slack = −0.1 ns (**hold violation**)

---

### 6. Types of Timing Path Analysis  
- **Reg-to-Reg:** Between two flip-flops  
- **In-to-Reg:** From input port to flip-flop  
- **Reg-to-Out:** From flip-flop to output port  
- **In-to-Out:** From input port to output port  
- **Clock gating:** Checks logic controlling clock signals  
- **Recovery / Removal:** For asynchronous set/reset paths  
- **Data-to-Data / Latch paths:** Includes time borrow and time given checks  

---

### 7. Clock Definitions and Parameters  
The clock defines timing references for all setup and hold checks.  

**Key terms:**  
- **Clock Period (T = 1/F):** Defines total available time per cycle  
- **Clk-to-Q Delay:** Time between an active clock edge and when the flip-flop output Q becomes valid  
- **Clock Skew:** Difference in clock arrival times between launch and capture flops  
- **Pulse Width / Duty Cycle:** Ensures valid clock transitions and prevents glitches  

These parameters are derived from the cell library (`.lib`) and used by STA tools like **OpenSTA**.

---

### 8. Path-Based and Graph-Based Analysis  
- **Graph-Based Analysis (GBA):** Considers all possible paths and reports the worst-case slack.  
- **Path-Based Analysis (PBA):** Focuses on the exact failing path and helps identify where delay optimization is needed.  

**Engineering Change Orders (ECOs)** are then used to fix timing by modifying critical gates or interconnects.

---

### 9. Timing Graph and DAG Representation  
A circuit can be represented as a **Directed Acyclic Graph (DAG)** where:
- Each **node** represents a cell or pin  
- Each **edge** represents delay (gate or wire)

From the graph:
- **AAT** is calculated forward (from inputs → outputs)  
- **RAT** is calculated backward (from outputs → inputs)  
- **Slack = RAT − AAT** at each node  

The node with the worst (most negative) slack represents the *critical path*.

---

### 10. Additional Timing Checks  
- **Slew / Transition:** Ensures signals rise/fall within allowed limits  
- **Load / Fan-out:** Keeps capacitance and driving strength within design rules  

These checks help prevent signal integrity and setup/hold issues.

---

### 11. Summary  
Static Timing Analysis is a **vectorless, mathematical** way to verify design timing by computing arrival and required times across all paths.  
It ensures that setup and hold constraints are met under all **process, voltage, and temperature (PVT)** conditions — without requiring testbench-based simulation.

✅ **Positive slack → Design meets timing**  
⚠️ **Negative slack → Timing violation (path must be optimized)**
