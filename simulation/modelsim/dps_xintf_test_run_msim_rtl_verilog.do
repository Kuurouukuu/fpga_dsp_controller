transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/AlteraProject/test_address_range_dsp {E:/AlteraProject/test_address_range_dsp/quadDecodeV2.v}
vlog -vlog01compat -work work +incdir+E:/AlteraProject/test_address_range_dsp {E:/AlteraProject/test_address_range_dsp/DeBounce_v.v}
vlog -vlog01compat -work work +incdir+E:/AlteraProject/test_address_range_dsp {E:/AlteraProject/test_address_range_dsp/sigmaV_decoder_top.v}
vlog -vlog01compat -work work +incdir+E:/AlteraProject/test_address_range_dsp {E:/AlteraProject/test_address_range_dsp/wb_compatible_encoder.v}
vlog -vlog01compat -work work +incdir+E:/AlteraProject/test_address_range_dsp {E:/AlteraProject/test_address_range_dsp/wishbone_arbiter.v}
vlog -vlog01compat -work work +incdir+E:/AlteraProject/test_address_range_dsp {E:/AlteraProject/test_address_range_dsp/multiplexer32.v}
vlog -vlog01compat -work work +incdir+E:/AlteraProject/test_address_range_dsp {E:/AlteraProject/test_address_range_dsp/multiplexer.v}
vlog -vlog01compat -work work +incdir+E:/AlteraProject/test_address_range_dsp {E:/AlteraProject/test_address_range_dsp/dps_xintf_test.v}
vlog -vlog01compat -work work +incdir+E:/AlteraProject/test_address_range_dsp {E:/AlteraProject/test_address_range_dsp/dualport_internal_ram.v}
vlog -vlog01compat -work work +incdir+E:/AlteraProject/test_address_range_dsp {E:/AlteraProject/test_address_range_dsp/clock_divisor_reset.v}
vlog -vlog01compat -work work +incdir+E:/AlteraProject/test_address_range_dsp {E:/AlteraProject/test_address_range_dsp/addressDecoder.v}
vlog -vlog01compat -work work +incdir+E:/AlteraProject/test_address_range_dsp {E:/AlteraProject/test_address_range_dsp/clock_divisor.v}
vlog -vlog01compat -work work +incdir+E:/AlteraProject/test_address_range_dsp {E:/AlteraProject/test_address_range_dsp/multiplexer_onehot.v}
vlog -vlog01compat -work work +incdir+E:/AlteraProject/sigmaV_decoder {E:/AlteraProject/sigmaV_decoder/clock_divisor.v}

