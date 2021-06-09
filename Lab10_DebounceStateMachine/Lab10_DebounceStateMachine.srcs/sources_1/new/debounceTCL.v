restart

add_force clk {0 0} {1 5} -repeat_every 10
add_force btnc 0
add_force btnd 0
run 1 ms

add_force btnc 1
run 6 ms

add_force btnc 0
run 6 ms

add_force btnc 1
run 6 ms

add_force btnc 0
run 6 ms

add_force btnc 1
run 6 ms

add_force btnc 0
run 6 ms

add_force btnc 1
run 6 ms

add_force btnc 0
run 6 ms
