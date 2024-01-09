# Modulo $n$ Counters
Modulo counters count from 0 to $n-1$. After $n-1$, the counter wraps around to 0. This is one implementation of these counters which increments on the rising edge of the input signal and is asynchronous. This block is used in clock-divide-by-$X$ circuits.

We can implement these counters by simply wiring the D flip-flops in a clever way. To start, we will need $\lceil \log_{2}(n) \rceil$ flip-flops to represent $n$ numbers (0 to $n-1$, inclusive). We can then look at the binary representation of the numbers:  

$0 \rightarrow 000$  
$1 \rightarrow 001$  
$2 \rightarrow 010$  
$3 \rightarrow 011$  
$4 \rightarrow 100$  
$5 \rightarrow 101$  
$...$

Note the first bit is always toggling between 0 and 1. The second bit also toggles between 0 and 1, but only when the first bit transitions from 1 to 0. In general, bit $n$ toggles when bit $n-1$ transitions from 1 to 0. 

To get bit toggling behaviour, we can take a D flip-flop and tie $\bar{Q}$ to $D$. This will cause the bit flip-flop to toggle every rising edge of the input signal, which acts the clock for the first flip-flop. However, for the bits / flip-flops beyond the first, we want them to toggle on the $1 \rightarrow 0$ transition (i.e, falling edge) of the previous bit / flip-flop. Fortunately, the $\bar{Q}$ has a rising edge whenever $Q$ has a rising edge, so we can use that for the clock signal for bits / flip-flops after the first. $Q_n$ is used to read the current count.

The last piece of the puzzle is the counter reset condition; that is, when the counter reaches $n$, the next increment should cause the counter to wrap back around to 0. This is not a problem for $n=2^{m}$, where $m \in \mathbb{Z}^{+}$ (values of $n$ that are powers of 2) as the circuit will naturally wrap around to 0 when incrementing $n-1$. However, when this is not the case, there are further states beyond $n$ (such as $n+1, n+2, ...$) which the circuit can reach. For example, if we have a mod 5 counter, we would have three flip-flops which would eventually loop from 0 to 7 rather than 0 to 4. To implement this resetting behaviour, we need some additional clear logic and flip-flops with asynchronous clearing.

If we look at the timing diagram for the counter so far, we will see that we want all the flops to output $0$ when the circuit holds the value $n$. So, for $n = 3$, we want to reset when $Q_1 = 1$ and $Q_0 = 1$. We can simply take $Q_1 \cdot Q_0$ (logical AND) and use it as the asynchronous clear signal for the flip-flops. But why do we need an asynchronous clear? Can we not use $Q_1 = 1$, $Q_0 = 0$ as the clear condition one cycle before? The issue with a synchronous clear is that the clock signal for all the flip-flops (except the first) is $Q$ from the previous flip-flop rather than the input signal. This means that the reset would not happen at the next rising edge of the input signal, but rather than rising edge of $Q$ from the previous flip-flop.

## Limitations
Although this circuit uses flip-flops, for timing purposes, it behaves similar to combinational logic, rather than sequential logic. Notice that each flip-flop beyond the first depends on the output of the previous flip-flop. In order to get a valid reading from the counter, we need give it enough time for the signal to propagate through the entire chain, similar to a ripple-carry adder.

## Implementations

### Modulo 3 Counter
An implementation and testbench for a modulo 3 counter is included. It can be simulated to generate a `.vcd` file using the included makefile: 
`make compile COMPILE_MODULE=mod3_counter_tb`

### Modulo 5 Counter
An implementation and testbench for a modulo 5 counter is included. It can be simulated to generate a `.vcd` file using the included makefile: 
`make compile COMPILE_MODULE=mod5_counter_tb`
