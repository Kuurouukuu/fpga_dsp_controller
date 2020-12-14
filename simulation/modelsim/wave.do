onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dps_xintf_tb/UUT/myClockDivisor/CLK_I
add wave -noupdate /dps_xintf_tb/UUT/myClockDivisor/RST_I
add wave -noupdate /dps_xintf_tb/UUT/myClockDivisor/ACK_I
add wave -noupdate -radix hexadecimal /dps_xintf_tb/UUT/myClockDivisor/DAT_I
add wave -noupdate /dps_xintf_tb/UUT/myClockDivisor/GNT
add wave -noupdate /dps_xintf_tb/UUT/myClockDivisor/STALL_I
add wave -noupdate -radix unsigned /dps_xintf_tb/UUT/myClockDivisor/DAT_O
add wave -noupdate -radix hexadecimal /dps_xintf_tb/UUT/myClockDivisor/ADR_O
add wave -noupdate /dps_xintf_tb/UUT/myClockDivisor/CYC_O
add wave -noupdate /dps_xintf_tb/UUT/myClockDivisor/STB_O
add wave -noupdate /dps_xintf_tb/UUT/myClockDivisor/WE_O
add wave -noupdate /dps_xintf_tb/UUT/myClockDivisor/sampling_clk
add wave -noupdate /dps_xintf_tb/UUT/myClockDivisor/divisor_update
add wave -noupdate -radix hexadecimal /dps_xintf_tb/UUT/myClockDivisor/address
add wave -noupdate /dps_xintf_tb/UUT/myClockDivisor/bus_trigger
add wave -noupdate -divider {Master 2}
add wave -noupdate /dps_xintf_tb/UUT/decoder/CLK_I
add wave -noupdate /dps_xintf_tb/UUT/decoder/RST_I
add wave -noupdate /dps_xintf_tb/UUT/decoder/ACK_I
add wave -noupdate -radix hexadecimal /dps_xintf_tb/UUT/decoder/DAT_I
add wave -noupdate /dps_xintf_tb/UUT/decoder/GNT
add wave -noupdate /dps_xintf_tb/UUT/decoder/STALL_I
add wave -noupdate -radix hexadecimal /dps_xintf_tb/UUT/decoder/DAT_O
add wave -noupdate -radix hexadecimal /dps_xintf_tb/UUT/decoder/ADR_O
add wave -noupdate /dps_xintf_tb/UUT/decoder/CYC_O
add wave -noupdate /dps_xintf_tb/UUT/decoder/STB_O
add wave -noupdate /dps_xintf_tb/UUT/decoder/WE_O
add wave -noupdate -divider Arbiter
add wave -noupdate /dps_xintf_tb/UUT/arbiter/CYC_I
add wave -noupdate /dps_xintf_tb/UUT/arbiter/CLK
add wave -noupdate /dps_xintf_tb/UUT/arbiter/RST
add wave -noupdate /dps_xintf_tb/UUT/arbiter/GNT
add wave -noupdate /dps_xintf_tb/UUT/arbiter/GNT_mux
add wave -noupdate /dps_xintf_tb/UUT/arbiter/CYC
add wave -noupdate /dps_xintf_tb/UUT/arbiter/state
add wave -noupdate /dps_xintf_tb/UUT/arbiter/state_next
add wave -noupdate /dps_xintf_tb/UUT/arbiter/GNT_local
add wave -noupdate /dps_xintf_tb/UUT/arbiter/bus_require
add wave -noupdate -divider DualPortRam
add wave -noupdate -radix hexadecimal /dps_xintf_tb/UUT/myDualPortRam/address_b
add wave -noupdate -radix hexadecimal /dps_xintf_tb/UUT/myDualPortRam/data_b
add wave -noupdate -radix hexadecimal /dps_xintf_tb/UUT/myDualPortRam/q_b
add wave -noupdate /dps_xintf_tb/UUT/pipelined_ack
add wave -noupdate -radix hexadecimal /dps_xintf_tb/UUT/slave_pipelined_address
add wave -noupdate /dps_xintf_tb/UUT/slave_pipelined_data
add wave -noupdate -radix unsigned /dps_xintf_tb/UUT/input_index
add wave -noupdate -radix unsigned /dps_xintf_tb/UUT/handle_index
add wave -noupdate -radix unsigned /dps_xintf_tb/UUT/state_pipelining
add wave -noupdate -divider DataFromSlaveMux
add wave -noupdate -radix hexadecimal /dps_xintf_tb/UUT/DATA_fromSlave_mux/IN1
add wave -noupdate /dps_xintf_tb/UUT/DATA_fromSlave_mux/IN2
add wave -noupdate /dps_xintf_tb/UUT/DATA_fromSlave_mux/SEL
add wave -noupdate -radix hexadecimal /dps_xintf_tb/UUT/DATA_fromSlave_mux/OUT
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2798 ps} 0}
configure wave -namecolwidth 141
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {980 ps} {2054 ps}
