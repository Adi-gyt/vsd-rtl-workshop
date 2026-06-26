# Create clock (10ns period = 100MHz; adjust if needed)
create_clock -name clk -period 10.0 -waveform {0.0 5.0} [get_ports clk]

# Input/output delays relative to clock (0 for zero-delay ideal case)
set_input_delay -clock clk 0.0 [remove_from_collection [all_inputs] [get_ports clk]]
set_output_delay -clock clk 0.0 [all_outputs]

# Clock uncertainty/jitter (0.1ns typical)
set_clock_uncertainty 0.1 [get_clocks clk]

# Load/multicycle if needed (skip for now)
# set_max_load 0.01 [all_outputs]  # Example: max fanout load
