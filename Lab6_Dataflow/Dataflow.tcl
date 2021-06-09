restart

add_force btnl 0
add_force btnc 0
add_force btnr 0
add_force btnu 0
add_force btnd 0
add_force sw 0000000100100011
run 10ns

add_force btnl 0
add_force btnc 1
run 10ns

add_force btnl 1
add_force btnc 0
run 10ns

add_force btnl 1
add_force btnc 1
run 10ns

add_force btnr 1
run 10ns

add_force btnu 1
run 10ns

add_force btnd 1
run 10ns