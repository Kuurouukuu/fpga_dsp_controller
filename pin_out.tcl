set_parameter -name CYCLONEII_SAFE_WRITE "\"RESTRUCTURE\"" 

set_location_assignment PIN_132 -to clk 

set_location_assignment PIN_118 -to nCS
set_location_assignment PIN_115 -to nWR 
set_location_assignment PIN_116 -to nRD 

set_location_assignment PIN_104 -to dsp_reset 
set_location_assignment PIN_94 -to dsp_done 
set_location_assignment PIN_110 -to dsp_interrupt 

set_location_assignment PIN_90 -to data[15] 
set_location_assignment PIN_89 -to data[14] 
set_location_assignment PIN_82 -to data[13] 
set_location_assignment PIN_81 -to data[12] 
#set_location_assignment PIN_80 -to data[11]
#set_location_assignment PIN_77 -to data[10] 
#set_location_assignment PIN_76 -to data[9]
#set_location_assignment PIN_75 -to data[8]
set_location_assignment PIN_77 -to data[11]
set_location_assignment PIN_80 -to data[10] 
set_location_assignment PIN_75 -to data[9]
set_location_assignment PIN_76 -to data[8] 

set_location_assignment PIN_117 -to data[7] 
set_location_assignment PIN_127 -to data[6] 
set_location_assignment PIN_128 -to data[5] 
set_location_assignment PIN_133 -to data[4] 
set_location_assignment PIN_134 -to data[3]
set_location_assignment PIN_135 -to data[2] 
set_location_assignment PIN_137 -to data[1]
set_location_assignment PIN_138 -to data[0] 


set_location_assignment PIN_139 -to address[13] 
set_location_assignment PIN_141 -to address[12]
set_location_assignment PIN_142 -to address[11] 
set_location_assignment PIN_143 -to address[10] 
set_location_assignment PIN_144 -to address[9]
set_location_assignment PIN_145 -to address[8]
set_location_assignment PIN_87 -to address[0] 
set_location_assignment PIN_70 -to address[1]
set_location_assignment PIN_69 -to address[2] 
set_location_assignment PIN_88 -to address[3] 
set_location_assignment PIN_72 -to address[4]
set_location_assignment PIN_74 -to address[5]
set_location_assignment PIN_84 -to address[6]
set_location_assignment PIN_86 -to address[7]

set_location_assignment PIN_58 -to trigger
set_location_assignment PIN_60 -to probe