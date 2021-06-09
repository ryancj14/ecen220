restart

# Set a repeating clock
add_force clk {0 0} {1 5} -repeat_every 10
add_force sw 111111111111
run 1000 us

add_force sw 111100000000
run 1000 us

add_force sw 010000010001
run 1000 us

