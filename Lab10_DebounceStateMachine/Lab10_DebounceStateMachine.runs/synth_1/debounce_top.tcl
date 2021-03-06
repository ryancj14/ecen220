# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {Common 17-41} -limit 10000000
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir {J:/ECEN 220 Labs/Lab10_DebounceStateMachine/Lab10_DebounceStateMachine.cache/wt} [current_project]
set_property parent.project_path {J:/ECEN 220 Labs/Lab10_DebounceStateMachine/Lab10_DebounceStateMachine.xpr} [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo {j:/ECEN 220 Labs/Lab10_DebounceStateMachine/Lab10_DebounceStateMachine.cache/ip} [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib -sv {
  {J:/ECEN 220 Labs/Lab8_SevenSegmentController/Lab8_SevenSegmentController.srcs/sources_1/new/SevenSegmentControl.sv}
  {J:/ECEN 220 Labs/Lab10_DebounceStateMachine/Lab10_DebounceStateMachine.srcs/sources_1/new/debounce.sv}
  {J:/ECEN 220 Labs/Lab10_DebounceStateMachine/Lab10_DebounceStateMachine.srcs/sources_1/new/debounce_top.sv}
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc {{J:/ECEN 220 Labs/Lab10_DebounceStateMachine/nexys4_220.xdc}}
set_property used_in_implementation false [get_files {{J:/ECEN 220 Labs/Lab10_DebounceStateMachine/nexys4_220.xdc}}]


synth_design -top debounce_top -part xc7a100tcsg324-1


write_checkpoint -force -noxdef debounce_top.dcp

catch { report_utilization -file debounce_top_utilization_synth.rpt -pb debounce_top_utilization_synth.pb }
