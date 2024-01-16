# Gray Code
Gray code is another two-bit representation of numbers. What is special about gray code is that each successive number requires only one bit to change. For example, we can take a look at the binary and gray code representations from 0 to 3:

|Decimal|Binary|Gray Code|
|------:|-----:|--------:|
|      0|    00|       00|
|      1|    01|       01|
|      2|    10|       11|
|      3|    11|       10|

Notice that 0 will still be represented as all 0s, and all possible permutations of bits still exist, but are reordered / remapped. Also note that a gray code mapping is not unique; the only requirement is that each subsequent number is only different by one bit. In the example above, we could have swapped the position of gray codes 01 and 10 and it would still be a gray code mapping.

Gray codes are used in applications where the property of one bit change per increment can be exploited (e.g., asynchronous FIFOs, error detection / correction). They are also used in ordering bits in Karnaugh maps (K-maps). 

So how do we generate gray codes from a binary value in hardware? It actually only needs one line in verilog: 
```verilog
gray = binary ^ (binary >> 1)
```
While this expression is very simple, it may synthesize into more ciruitry than required. Instead, we can write the same expression without using the shift operator: 

```verilog
gray = {binary[LENGTH-1], binary[LENGTH-1:1] ^ binary[LENGTH-2:0]}
```

where `LENGTH >= 2` is the number of bits in `binary`.

What about converting gray code back to binary? If we take a look at 3-bit gray code and binary (available in next section), we get the following expressions:  
$B_2 = G_2 $  
$B_1 = G_2 \oplus G_1 = B_2 \oplus G_1$  
$B_0 = G_2 \oplus G_1 \oplus G_0 = B_1 \oplus G_0$  

Unlike going from binary to gray code, if we want to go from gray code to binary, each bit requires all more-significant bits to be resolved before it can be resolved. This is not desireable as we now have a critical path that increases with the number of bits. If a check for equality between a binary and gray coded value is necessary, it would be best to convert the binary value to gray code rather than the other way around. To implement a gray to binary converter in verilog, we can do something like:

```verilog
for (i = 0; i < LENGTH; i = i + 1) binary[i] = (gray >> i)
``` 

To avoid the use of the shift operator (which may synthesize to a shift register), we can do the following instead:

```verilog
for (i = LENGTH - 2; i >= 0; i = i - 1) binary_o[i] = binary_o[i+1] ^ gray_i[i]
```

Keep in mind these conversions only generate one possible mapping; there may be situations where a different mapping would be better. For an interesting example of using a different mapping to solve a problem, check out [this EE Times article](https://www.eetimes.com/yet-another-gray-code-conundrum-part-1/). I am interested in the follow-ups (on his blog) he mentions, but unfortunately, at the time of writing, the link to his blog returns status 503.

## Gray Code Counters
Something interesting to consider is whether a gray code counter would be better than a regular binary counter. Activation frequency increases power usage, so if only one bit needs to change with each increment, could we see power savings if we use gray counters instead of binary counters? Using a normal binary counter and using the conversion method above would be out of the question as we would still have the binary counter, but we are now adding additional circuitry on top. Let us consider a scenario where we want a 3-bit synchronous counter. The truth tables for the gray and binary counters (respectively) are as follows:

|$G_2$|$G_1$|$G_0$| |$G_2^+$|$G_1^+$|$G_0^+$|
|----:|---:|-----:|-|------:|------:|------:|
|    0|   0|     0| |      0|      0|      1|
|    0|   0|     1| |      0|      1|      1|
|    0|   1|     1| |      0|      1|      0|
|    0|   1|     0| |      1|      1|      0|
|    1|   1|     0| |      1|      1|      1|
|    1|   1|     1| |      1|      0|      1|
|    1|   0|     1| |      1|      0|      0|
|    1|   0|     0| |      0|      0|      0|

|$B_2$|$B_1$|$B_0$| |$B_2^+$|$B_1^+$|$B_0^+$|
|----:|---:|-----:|-|------:|------:|------:|
|    0|   0|     0| |      0|      0|      1|
|    0|   0|     1| |      0|      1|      0|
|    0|   1|     0| |      0|      1|      1|
|    0|   1|     1| |      1|      0|      0|
|    1|   0|     0| |      1|      0|      1|
|    1|   0|     1| |      1|      1|      0|
|    1|   1|     0| |      1|      1|      1|
|    1|   1|     1| |      0|      0|      0|

Putting these into K-maps, we get the following expressions:  
$G_2^+ = G_1\bar{G}_0 + G_2G_0$  
$G_1^+ = G_1\bar{G}_0 + \bar{G}_2G_0$  
$G_0^+ = \bar{G}_2\bar{G}_1 + G_2G_1$  

$B_2^+ = B_2\bar{B}_1 + B_2B_1\bar{B}_0 + \bar{B}_2B_1B_0$  
$B_1^+ = B_1\bar{B}_0 + \bar{B}_1B_0$  
$B_0^+ = \bar{B}_0$  

From this, we can see that (in terms of 2-input logic gates) the gray code counter uses 8 gates (5 AND gates -- the $G_1\bar{G}_0$ term is shared for $G_2^+$ and $G_1^+$, 3 OR gates, and NOT gates are not required as the negated signals are provided by the flip-flops), and the binary counter needs 9 (6 AND gates -- $B_1\bar{B}_0$ are used for both $B_2^+$ and $B_1^+$, 3 OR gates). If 3-input logic gates are available, then the binary counter can reduce the number of gates to 8. At the end of the day, I am not sure which counter wins here (it boils down to the difference in area and power of 3-input and 2-input gates). However, for power, let us not forget that the act of bit flipping consumes additional power, and while each increment for the gray counter only requires one bit to change, the binary counter requires an average of $14/8$ bit changes per increment. This could mean a significant power savings due less dynamic power consumed by the gates.

It is also interesting how balanced the logic for the gray code counter is compared to the binary counter. Each expression is two 2-input AND gate in parallel, feeding into an OR gate. On the other hand, while the LSB of the binary counter needs no additional logic, if only 2-input gates are used, we have a lot of cascading in the MSB logic. Even if 3-input gates are allowed, they have longer propagation delays than their 2-input counterparts (greater logical effort). This would mean that the gray counter could be clocked at a higher frequency than the binary counter (as clock frequency is limited by the longest propagation time).

While it certainly seems like gray counters are very promising, I am ultimately uncertain. There are posts online suggesting that gray counters have improved power efficiency compared to binary counters (such as this [EE Times article](https://www.eetimes.com/gray-code-fundamentals-part-2/)), but there are also resources that suggest otherwise (such as this [white paper published by Actel](https://www.microsemi.com/document-portal/doc_view/131579-power-aware-fpga-design-white-paper) - Figure 18). I noticed the white paper from Actel was geared towards FPGA design, and perhaps the discrepency is due to the gray counter requiring LUTs for the logic, while the FPGA already contains optimized binary counters. I saw one post that made a good point: if gray counters are truly more power efficient than binary counters, why is the industry not making a big push to gray counters? Personally, while I lean towards gray counters, I will reserve my judgement as I have not seen any definitive proof yet. It would be interesting to compare the power estimation results from running a gray counter and binary counter through Design Compiler.

What is a bit of an issue is the application of gray counters. What if we need to compare the counter's current value to a binary value? Unless we are only comparing it to 0 (e.g., a spin-down counter), we would need to convert the binary value to gray code or the gray code back to binary (although we would like to avoid the latter as the circuit requires a lot of cascading). Additionally, I do not currently know of a way to generate a gray counter with an arbitrary number of bits (without having to stick a binary to gray code converter onto a binary counter); if this is a process that must be done by hand for a large counter, or large number of uniquely-sized counters, it may not be worth the effort.

Regarding that last note, something just came into mind: what if a Python script was used to generate a truth table and (unsimplified) logical expressions for an $N$-bit gray counter, and then the expressions were simplified with a library such as SymPy? The logical expressions can then be copy-pasted into a module to define the $N$-bit gray counter. It makes sense in my head but I have yet to play with the SymPy library. This came up while I was thinking for a way to use gray code counters instead of a binary counters plus binary-to-gray converters in my asynchronous FIFO implementation. Perhaps this is something worth looking into.

## Implementations
Implementations for a binary-to-gray converter and gray-to-binary coverter, as well as a single testbench that exercises both at the same time, are included. I decided to test both at the same time for convenience (converting binary to gray code and back should return the original binary). It can be simulated to generate a `.vcd` file using the included makefile:  
`make compile COMPILE_MODULE=gray_code_converters_tb`

An implementation and testbench for a synchronous 3-bit gray code counter is included. A gray-to-binary converter was added in the testbench to help with debugging. It can be simulated to generate a `.vcd` file using the included makefile:  
`make compile COMPILE_MODULE=gray_counter3_sync_tb`
