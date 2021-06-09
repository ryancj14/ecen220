restart

add_force clk {0 0} {1 5} -repeat_every 10
add_force Sin 1
add_force Reset 1
add_force Received 0
run 52083 ns

add_force Reset 0
run 52083 ns

add_force Sin 0
run 52083 ns

add_force Sin 1
run 52083 ns

add_force Sin 1
run 52083 ns

add_force Sin 1
run 52083 ns

add_force Sin 0
run 52083 ns

add_force Sin 1
run 52083 ns

add_force Sin 1
run 52083 ns

add_force Sin 0
run 52083 ns

add_force Sin 1
run 52083 ns

add_force Sin 1
run 52083 ns

add_force Received 0
run 52083 ns

add_force Received 1
run 52083 ns