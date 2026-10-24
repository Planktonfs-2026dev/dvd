# Typical-corner Liberty library
set lib $::env(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# Clock period T in ns, set from the shell (default 10 ns)
if {[info exists ::env(CLK_PERIOD)]} {
    set T $::env(CLK_PERIOD)
} else {
    set T 10.0
}

# 1. Read the cell timing library
read_liberty $lib

# 2. Read and link the netlist
read_verilog synth/mult_array_netlist.v
link_design mult_array

# 3. Define the clock
create_clock -name clk -period $T [get_ports clk]

# 4. Input arrival time (all inputs except clk)
set_input_delay 1.0 -clock clk [delete_from_list [all_inputs] [get_ports clk]]

# 5. Output required time
set_output_delay 1.0 -clock clk [all_outputs]

# 6. Print the period and worst setup slack
puts "CLK_PERIOD = $T"
report_worst_slack -max

# 7. Save the critical path report
redirect sta/mult_array_timing.rpt {
    report_checks -path_delay max -digits 3
}
