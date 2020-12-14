onerror {resume}
quietly WaveActivateNextPane {} 0
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
add wave -noupdate /dps_xintf_tb/UUT/decoder/encoder_require
add wave -noupdate -radix hexadecimal /dps_xintf_tb/UUT/decoder/sigmaDecoder/velocity
add wave -noupdate /dps_xintf_tb/UUT/decoder/bus_trigger
add wave -noupdate -divider {Shared Bus}
add wave -noupdate /dps_xintf_tb/UUT/GNT
add wave -noupdate -radix hexadecimal /dps_xintf_tb/UUT/DAT
add wave -noupdate -radix hexadecimal /dps_xintf_tb/UUT/ADR
add wave -noupdate /dps_xintf_tb/UUT/STB
add wave -noupdate /dps_xintf_tb/UUT/WE
add wave -noupdate /dps_xintf_tb/UUT/CYC
add wave -noupdate /dps_xintf_tb/UUT/ACK
add wave -noupdate /dps_xintf_tb/UUT/STALL
add wave -noupdate -divider DualPortRam
add wave -noupdate -radix hexadecimal /dps_xintf_tb/UUT/myDualPortRam/address_b
add wave -noupdate -radix hexadecimal /dps_xintf_tb/UUT/myDualPortRam/data_b
add wave -noupdate /dps_xintf_tb/UUT/myDualPortRam/wren_b
add wave -noupdate -radix hexadecimal /dps_xintf_tb/UUT/myDualPortRam/q_b
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3257 ps} 0}
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {5250 ps}
