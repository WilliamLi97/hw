# Reset Synchronizer
There are reasons for and against using synchronous vs asynchronous resets. Flip-flops with synchronous resets can have a smaller area requirement, but come with the condition that they only reset at the clock edge. This means that if there is no clock present (e.g., a portion of the chip is clock gated to save power), any reset signal propagated during this team would be ignored. Asynchronous resets certainly have their place, but they come with their own potential issues: what if we release the reset signal very close to the clock edge? This could lead to metastability.

Instead of having a fully asynchronous reset, what should instead use an asynchronous reset, synchronous release scheme. This means adding additional circuitry for the reset to hold it for number of clock cycles, and releasing it at the next clock edge. This guarantees that the reset release will happen right after the edge of the clock signal, giving flip-flops the rest of the clock cycle to stabilize. This topic is discussed in much more detail in [this paper](http://www.sunburst-design.com/papers/CummingsSNUG2003Boston_Resets.pdf).

To implement a synchronous release, we just need a chain of two clocked flip-flops with asynchronous resets. The inactive reset value (i.e., 1 if active low) is piped into this flip-flop chain. The output is a signal which will follow the reset signal, but will only be released after a clock edge (because the chain is synchronous, the value does not update unless the clock is present).

## Implementation
An implementation and testbench for an active low reset synchronizer is included. It can be simulated to generate a `.vcd` file using the included makefile:  
`make compile COMPILE_MODULE=reset_synchronizer_tb`
