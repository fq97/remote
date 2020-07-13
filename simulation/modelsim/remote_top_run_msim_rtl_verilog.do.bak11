transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/fumin/Documents/FPGA_proj/remote {C:/Users/fumin/Documents/FPGA_proj/remote/remote_top.sv}
vlog -sv -work work +incdir+C:/Users/fumin/Documents/FPGA_proj/remote {C:/Users/fumin/Documents/FPGA_proj/remote/clk_38k.sv}
vlog -sv -work work +incdir+C:/Users/fumin/Documents/FPGA_proj/remote {C:/Users/fumin/Documents/FPGA_proj/remote/samsung_command.sv}
vlog -sv -work work +incdir+C:/Users/fumin/Documents/FPGA_proj/remote {C:/Users/fumin/Documents/FPGA_proj/remote/ir_drive.sv}
vlog -sv -work work +incdir+C:/Users/fumin/Documents/FPGA_proj/remote {C:/Users/fumin/Documents/FPGA_proj/remote/samsung_protocol.sv}

