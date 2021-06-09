restart

run 100 ns

add_force clk {0 0} {1 5ns} -repeat_every 10ns

add_force we 0
add_force datain 0000
add_force waddr 000
run 10 ns

add_force datain 1101
add_force we 1
run 10 ns

add_force datain 0110
add_force we 1
add_force waddr 011
run 10 ns

add_force we 0
add_force raddr1 000
add_force raddr2 000
run 10 ns

add_force we 1
add_force waddr 100
run 10 ns

add_force raddr1 011
add_force raddr2 001
run 10 ns

add_force raddr2 010
run 10 ns

add_force raddr2 011
run 10 ns

add_force raddr2 100
run 10 ns

add_force raddr2 101
run 10 ns

add_force raddr2 110
run 10 ns