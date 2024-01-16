# Clock-divide-by-X

The purpose of this circuit is to reduce the frequency of a clock signal by a factor of $X$ or increase the period $T$ by a factor of $X$. Although it is unlikely that this circuit will be used in a real-world situation, this is (apparently) a common interview question.

The first order of business is a mechanism to determine how many clock cycles have passed. While we can do this by incrementing a register and checking when the counter reaches $\frac{T}{2}$, there is a more clever solution using a modulo $n$ counter (more specifically, a modulo $X$ counter). An understanding of the modulo $n$ counter will be assumed; if this is not the case, review the `mod_n_counter` directory.

We start by using the original clock signal as an input for the modulo $X$ counter. When the count reaches $\lceil \frac{X}{2} \rceil$, we want the new clock signal to go high, so we will need to add logic to check the current count. If $X$ is a power of 2, we simply need to check the most significant bit of the count (since it is $0$ continuously for half of the possible states, and $1$ continuously for the other half of possible states). In general, to derive the logic necessary, we can examine the truth tables.

For a clock-divide-by-3 circuit, we would want the following behaviour based on the count:
|$Q_1$|$Q_0$|Output|
|----:|----:|-----:|
|    0|    0|     0|
|    0|    1|     0|
|    1|    0|     1|

Note that for state $Q_1Q_0 = 11$, the counter would have wrapped back to $Q_1Q_0 = 00$, so we do not need to consider that state. For a clock-divide-by-3 circuit, we would simply need to check for $Q_1$: if $Q_1$ is high, the new clock signal should be as well.

For a clock-divide-by-5 circuit, we would need the following behaviour:
|$Q_2$|$Q_1$|$Q_0$|Output|
|----:|----:|----:|-----:|
|    0|    0|    0|     0|
|    0|    0|    1|     0|
|    0|    1|    0|     0|
|    0|    1|    1|     1|
|    1|    0|    0|     1|

From the truth table, we see that the new clock signal should be high when the expression $Q_2 + Q_1 Q_0$ is high.

Once we have the output from the modulo $X$ counter figured out, if $X$ is even, we are done; the signal output from this logic will be a clock with a period increased by a factor of $X$ and 50% duty cycle. However, if $X$ is odd, we need to extend the high portion of the new clock by half a clock cycle (of the original clock). To do this, we can use an extra D flip-flop. Normally, when we send a signal through a D flip-flop sensitive to the positive edge of the clock, we incur a 1-cycle delay. However, if we look at a timing diagram for a flip-flop that is sensitive to the negative edge of the clock, we see that the delay is half a clock cycle. With this, we can send the output into a flip flop with a negative edge sensitivity to get the same signal, but delayed by half a clock cycle. Then we OR the two signals, resulting in a signal that is extended by half a clock cycle. Note that unlike the modulo counter, we use the original clock signal because we are trying to add delay relative to the original clock signal, and we can use a flip flop with positive edge sensitivity if we NOT the clock signal going into it.

## Limitations
Due to the use of the modulo $n$ counter, we have the same drawback in that we have to wait for the signal to propagate through each flip-flop in the counter before the value being read is valid.
The reason why this type of circuit is unlikely to be practical is because it is generally a bad idea to add logic onto the clock path. By introducing logic to the clock path, it could cause issues with delay, skew, and power (clocks have activity factor $\alpha = 1$). It is potentially exacerbated in FPGAs due to routing (clock signal has to travel to the clock divider logic, then to wherever it is needed, incurring additional delay and occupying interconnects on the way) and the original clock already having a connection to all the registers on the chip (it is already optimized).

## Implementations
### Clock-divide-by-3
An implementation and testbench for a clock-divide-by-3 circuit is included. It can be simulated to generate a `.vcd` file using the included makefile:  
`make compile COMPILE_MODULE=clock_divider3_tb`

### Clock-divide-by-5
An implementation and testbench for a clock-divide-by-5 circuit is included. It can be simulated to generate a `.vcd` file using the included makefile:  
`make compile COMPILE_MODULE=clock_divider5_tb`
