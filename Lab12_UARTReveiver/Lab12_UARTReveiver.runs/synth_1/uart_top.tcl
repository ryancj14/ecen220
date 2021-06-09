# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir {J:/ECEN 220 Labs/Lab12_UARTReveiver/Lab12_UARTReveiver.cache/wt} [current_project]
set_property parent.project_path {J:/ECEN 220 Labs/Lab12_UARTReveiver/Lab12_UARTReveiver.xpr} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo {j:/ECEN 220 Labs/Lab12_UARTReveiver/Lab12_UARTReveiver.cache/ip} [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib -sv {
  {J:/ECEN 220 Labs/Lab12_UARTReveiver/Lab12_UARTReveiver.srcs/sources_1/imports/sources_1/new/tx.sv}
  {J:/ECEN 220 Labs/Lab12_UARTReveiver/Lab12_UARTReveiver.srcs/sources_1/imports/sources_1/imports/new/SevenSegmentControl.sv}
  {J:/ECEN 220 Labs/Lab12_UARTReveiver/Lab12_UARTReveiver.srcs/sources_1/new/rx.sv}
  {J:/ECEN 220 Labs/Lab12_UARTReveiver/Lab12_UARTReveiver.srcs/sources_1/imports/sources_1/imports/new/debounce.sv}
  {J:/ECEN 220 Labs/Lab12_UARTReveiver/Lab12_UARTReveiver.srcs/sources_1/new/uart_top.sv}
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc {{J:/ECEN 220 Labs/Lab12_UARTReveiver/Lab12_UARTReveiver.srcs/constrs_1/imports/Lab10_DebounceStateMachine/nexys4_220.xdc}}
set_property used_in_implementation false [get_files {{J:/ECEN 220 Labs/Lab12_UARTReveiver/Lab12_UARTReveiver.srcs/constrs_1/imports/Lab10_DebounceStateMachine/nexys4_220.xdc}}]


synth_design -top uart_top -part xc7a100tcsg324-1


write_checkpoint -force -noxdef uart_top.dcp

catch { report_utilization -file uart_top_utilization_synth.rpt -pb uart_top_utilization_synth.pb }
