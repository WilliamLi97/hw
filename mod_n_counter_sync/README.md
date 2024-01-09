# Synchronous modulo $n$ counter
By simply wiring the D flip-flops in a clever way, an asynchronous modulo $n$ counter can be created. However, the asynchronous modulo $n$ counter must wait for the signal to propagate through all the flip-flops (similar to a ripple-carry adder). A potential consequence of this is reducing the clock speed to meet timing constraints. Luckily, there is an implementation of the modulo $n$ counter which is synchronous (i.e., all the flip-flops share the same clock signal). In the synchronous version, each flip-flop depends on the previous state rather than the previous flip-flop. This means we are now waiting on the logic to calculate the next state rather than the propagation through all the flip-flops in the asynchronous version.

We can start by looking at the transition table for a modulo 3 counter (next state is denoted by $^+$):
|$Q_1$|$Q_0$|     |$Q_1^+$|$Q_0^+$|
|----:|----:|-----|------:|------:|
|    0|    0|     |      0|      1|
|    0|    1|     |      1|      0|
|    1|    0|     |      0|      0|
|    1|    1|     |      0|      0|

Notice that both state $Q_1Q_0 = 10$ and $Q_1Q_0 = 11$ result in state $Q_1^+Q_0^+ = 00$. If we draw a state machine diagram for this, we actually see that there is no state transitions into the $Q_1Q_0 = 11$ state, and so we can use "don't care" (DC) for the output of this state to simplify the logic:

|$Q_1$|$Q_0$|     |$Q_1^+$|$Q_0^+$|
|----:|----:|-----|------:|------:|
|    0|    0|     |      0|      1|
|    0|    1|     |      1|      0|
|    1|    0|     |      0|      0|
|    1|    1|     |     DC|     DC|

We can then use this table to derive the logical expressions for $Q_1^+$ and $Q_0^+$. This can be done using Karnaugh maps (K-maps) or by simply examining the table. After this process, we arrive at $Q_1^+ = Q_0$ and $Q_0^+ = \bar{Q}_1 \bar{Q}_0$.

We can follow the same process for $n = 5$ and so on:

|$Q_2$|$Q_1$|$Q_0$|     |$Q_2^+$|$Q_1^+$|$Q_0^+$|
|----:|----:|----:|-----|------:|------:|------:|
|    0|    0|    0|     |      0|      0|      1|
|    0|    0|    1|     |      0|      1|      0|
|    0|    1|    0|     |      0|      1|      1|
|    0|    1|    1|     |      1|      0|      0|
|    1|    0|    0|     |      0|      0|      0|
|    1|    0|    1|     |     DC|     DC|     DC|
|    1|    1|    0|     |     DC|     DC|     DC|
|    1|    1|    1|     |     DC|     DC|     DC|

We find that for $n = 5$:  
$Q_2^+ = Q_1 Q_0$  
$Q_1^+ = Q_1 \bar{Q}_0 + \bar{Q}_1 Q_0 = Q_1 \oplus Q_0$  
$Q_0^+ = \bar{Q}_2 \bar{Q}_0$

## Limitations
Due to the use of DCs, the logic requirement for state transitions is reduced, but it comes at the cost of inconsistent behaviour if _somehow_ the circuit does end up in that state. While it is unlikely (at least on Earth), it is possible that background radiation causes a bit flip. To improve robustness, the DCs can be removed before deriving the logic for the various flip-flops.

## Implementations
### Synchronous modulo 3 counter
An implementation and testbench for a synchronous modulo 3 counter is included. It can be simulated to generate a `.vcd` file using the included makefile:  
`make compile COMPILE_MODULE=mod3_counter_tb`

### Synchronous modulo 5 counter
An implementation and testbench for a synchronous modulo 5 counter is included. It can be simulated to generate a `.vcd` file using the included makefile:  
`make compile COMPILE_MODULE=mod5_counter_tb`
