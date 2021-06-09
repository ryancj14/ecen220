restart

add_force clk {0 0} {1 5} -repeat_every 10
add_force Din 10000101
add_force Reset 1
add_force Send 0
run 530000 ns

add_force Reset 0
add_force Send 1
run 530000 ns

add_force Din 11111001
run 1060000 ns