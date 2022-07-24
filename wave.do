vlib work
vlog SHA256_core.sv SHA256_operations.sv top_tb.sv top.sv SHA256_controller.sv
vsim dut_controller

add wave *
log *


# add wave -position end  sim:/dut_sha256_core/mycore/T1
# add wave -position end  sim:/dut_sha256_core/mycore/T2
# add wave -position end  sim:/dut_sha256_core/mycore/hash_val_reg

add wave -position end  sim:/dut_controller/dut/next_state
add wave -position end  sim:/dut_controller/dut/current_state
add wave -position end  sim:/dut_controller/dut/timer
add wave -position end  sim:/dut_controller/dut/timer_enable
add wave -position end  sim:/dut_controller/dut/nonce
add wave -position end  sim:/dut_controller/dut/hash_result
add wave -position end  sim:/dut_controller/dut/hash_result_reversed
add wave -position end  sim:/dut_controller/dut/init_source
add wave -position end  sim:/dut_controller/dut/value_source
add wave -position end  sim:/dut_controller/dut/SHA256_start
add wave -position end  sim:/dut_controller/dut/index
add wave -position end  sim:/dut_controller/dut/satisfactory_results





run -all
