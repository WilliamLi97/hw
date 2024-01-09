# Full adder
The full adder expands on the capabilities of the half adder by also accounting for a carry input. This allows a chain of just full adders to be complete an add operation (i.e., ripple carry adders). There are multiple ways to implement a full adder, we will go over two ways: deriving a circuit from the full adder truth table, and using two half adders. Note, however, that while it is not covered here, as there often is, there are optimizations that we can do on a transistor level. In implementing the full adder using two half-adders (plus an extra OR gate), an understanding of the half adder will be assumed. If this is not the case, review the directory on half adders.

Let us start by examining the truth table for the full adder, so we can derive the logical expressions for the outputs:
|$C_{in}$|$A$|$B$|   |$C_{out}$|$S$|
|-------:|--:|--:|---|--------:|--:|
|       0|  0|  0|   |        0|  0|
|       0|  0|  1|   |        0|  1|
|       0|  1|  0|   |        0|  1|
|       0|  1|  1|   |        1|  0|
|       1|  0|  0|   |        0|  1|
|       1|  0|  1|   |        1|  0|
|       1|  1|  0|   |        1|  0|
|       1|  1|  1|   |        1|  1|

Using Karnaugh maps (K-maps) or Boolean algebra, we get:  
$C_{out} = AB + C_{in}B + C_{in}A$  
$C_{out} = AB + (A + B)C_{in}$  

$S = C_{in}\bar{A}\bar{B} + \bar{C}_{in}\bar{A}B + C_{in}AB + \bar{C}_{in}A\bar{B}$  
$S = C_{in}(\bar{A}\bar{B} + AB) + \bar{C}_{in}(\bar{A}B+A\bar{B})$  
$S = C_{in}\overline{(A \oplus B)} + \bar{C}_{in}(A \oplus B)$  
$S = C_{in} \oplus A \oplus B$

At this point, we can simply implement these two signals and we are done. Now that we have these equations, we can also understand how to implement the full adder using two half adders. Recall that a half adder implements:
$C_{ha} = AB$
$S_{ha} = A \oplus B$

If we take $S_{HA}$ from the first half adder and connect it to an input of the second half adder, and $C_{in}$ to the other input of the second half adder, we have:
$C_{ha1} = C_{in}S_{ha0} = C_{in}AB$
$S_{ha1} = C_{in} \oplus S_{ha0} = C_{in} \oplus A \oplus B$

We see that $S_{ha1}= S_{fa}$ is already in the correct form, but we want $C_{fa} = C_{ha1} + AB$. Fortunately, we have $C_{ha0} = AB$, so we can implement $C_{fa} = C_{ha1} + C_{ha0}$.

## Implementations
### Full adder
An implementation and testbench for a full adder is included. It can be simulated to generate a `.vcd` file using the included makefile:  
`make compile COMPILE_MODULE=full_adder_tb`

### Double half adder
An implementation and testbench for a full adder using two half adders is included. It can be simulated to generate a `.vcd` file using the included makefile:  
`make compile COMPILE_MODULE=double_half_adder_tb`
