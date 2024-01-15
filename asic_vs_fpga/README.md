# ASIC vs FPGA Design
This directory does not contain any implementations, just some notes on important differences between ASIC and FPGA design. While both are a way to implement hardware designs, they have important tradeoffs that should be considered when deciding whether to implement a design as an ASIC or on a FPGA.

## Application-Specific Integrated Circuits (ASICs)
Let us first start with some background knowledge on ASICs. As the name suggests, these circuits are designed to perform a specific task, and only that task; once they are created, we cannot re-program them to do anything else. With ASIC design, whatever we design is whatever we get; we do not have to pay additional area nor power for circuitry that we did not need. In addition to this, we have much more control over things such as circuit placement and signal routing. While there is addtional work required to do so, we can exploit these things to optimize the design.

## Field Programmable Gate Arrays (FPGAs)
FPGAs, as the name suggests, consists of an array of circuits already in silicon, and can be programmed to implement hardware designs. More specifically, FPGAs contain a massive amount of flip-flops, look-up tables (LUTs), and elements are massively interconnected. The LUTs are essentially programmable truth tables, and as such can be programmed to implement any logical expression. LUTs are generally able to take more than just two inputs and as such, a single LUT can implement a fairly complex logical expression. Ultimately, however, more than one LUT may be needed to implement a combinational logic block. The structure of an FPGA affords us much more flexibility, but necessitates purchasing more circuitry than necessary for our designs (if there is not enough flip-flops or LUTs on the chip, we will be unable to load our design onto it). Routing becomes a challenge as various blocks of logic need to connect to each other, but interconnects are pre-defined. The extra circuitry and interconnects also leads to more power consumption (as data paths may be longer than they need to be).

## Performance
As the descriptions suggest, designs implemented as an ASIC have greater performance than FPGAs. This is not by a small margin, either. This performance difference can be largely attributed to features required for the flexibility afforded by FPGAs. They result in timing delays that may ultimately require slowing down the clock, and thereby lowering performance. As such, it is common for FPGAs to operate at much lower frequencies than ASICs. I will go into further detail regarding routing and LUTs, but the list of factors are not limited to just these two.

As the silicon is already set in stone, FPGAs are necessarily massively interconnected in order to allow designers to connect signals as they need. However, the resources on an FPGA are not infinite, and once the more direct paths are used up, data paths may need to span lengthy detours. While propagation delays on data paths affect all circuit designs, ASIC design is not limited by pre-determined routing resources and data paths are generally more direct.

As mentioned prior, the LUTs are what allow FPGAs to implement any type of logical expression. LUTs are generally fast and the difference between the propagation delay of an expression implemented as a LUT vs gates is likely not too significant. What _is_ significant, however, is delays caused by routing. If we only have a maximum of 4 inputs for our LUTs, and we need to implement a 5-input expression, we now need multiple LUTs, and we extra incur routing delay (which would have been avoided in an ASIC).

## Area
ASICs are much more space efficient than FPGAs. As such, a design that is implemented on an FPGA may require multiple times the area of an ASIC implementation of the same design. I am not too familiar with the implementations of the hardware in an FPGA, but from my understanding:

FPGAs generally include a large amount of flip-flops (generally more than necessary) as requirements vary from design to design. However, if we ever run out of flip-flops, we have to use LUTs to implement flip-flops, causing our design to explode in of resource usage.

LUTs can be quite compact, but are again costly (this time area-wise) if we need multiple LUTs to implement a single expression. 

A substantial part of the area of an FPGA is used just for routing signals. Again, this is simply a necessity of FPGAs and while a lot of engineering goes into improving the interconnects and routing, it is a limitation of FPGAs.

## Power
ASICs are significantly more power efficient than FPGAs. This is another area where the ability to make optimizations to the circuit design make the difference. There are numerous things that contribute to increased power usage by FPGAs:

The most obvious factor is all the additional circuitry that the design will never use. Chances are, the FPGA that a design is deployed on will have more circuitry than the design actually uses. If nothing else, there will be constant power usage due to leakage.

As mentioned previously, an FPGA contains a huge amount of flip-flops, and each one of these has a connection to the clock tree. According to [this Semiconductor Engineering article](https://semiengineering.com/the-trouble-with-clock-trees/), clock tree power consumption mainly arises from capacitance, switching activity, and wire length. While switching activity can be reduced with clock gating, the extra capacitance and wires will add extra power consumption to the design.

A wire's resistance is proportional to its length, so the more longer data connections are, the greater the resistive losses. Data connections on an FPGA are generally longer than on an ASIC and as a result, more power is used for data movement.

## Cost
Unlike performance, area, and power, there is no definitive winner without considering the intended use-case. 

The fabrication of an ASIC has a massive upfront cost due to having to create a mask for the lithography process. However, once the initial cost has been paid, the per-unit cost of an ASIC is much lower than that of an FPGA. If enough units of the ASIC are produced, the upfront cost can be amortized to a point where the ASIC is more cost efficient than the FPGA. 

## Bugs
No matter how hard we try, chances are, there will be bugs that were not yet caught at the time of tape-out. For an ASIC, there is no way to fix them. If the bugs are not critical, we can employ feature cutting (including scaling back projected performance metrics). However, if the bugs are critical, the only option we have is to re-spin the design. In other words, we have to spend the upfront cost again to fabricate a revised design. For designs deployed on an FPGA, the FPGA just needs to be re-programmed with the revised design (similar to patching software bugs).

It should also be mentioned that even before tape out, once the ASIC design has moved on to synthesis, place and route, and beyond, bugs become significantly harder to fix. RTL designers can no longer make edits without needing to synthesize the design again (this can take days). An engineering change order (ECO) will need to be issued, and bug fixes will have to be done on the gate level, and reflected in place and route. 

## Development Style
With ASIC development, the cost of the circuit is directly related to the components it consists of. As such, logic (gates) are relatively cheap, while flip-flops are relatively expensive (for a flip-flop containing two D latches, eight logic gates are needed). FPGAs are the opposite; because they come pre-loaded with a massive amount of flip-flops, and comparitively few LUTs, and so we can use flip-flops liberally, but should try to be conservative with LUTs. Additionally, latches and flip-flops, when deployed on an FPGA, use the same resources (that is, while latches and flip-flops function differently, a latch on an FPGA could have been used as a flip-flop instead), so it is best to use flip-flops whenever possible.

Due to the difficulty of resolving bugs with ASICs, modern ASIC design places a heavy emphasis on verification. It is extremely important that the design is as close to issue-free as possible before tape out as the consequences can be very costly. FPGA designers, on the other hand, can rest easy (or at least easier) as they can deploy patches similar to software development. It should be noted, however, that synthesizing a large project for an FPGA can take several hours, and dumping signals may need the design to be synthesized again.

## Applications
For any design, it usually comes down to cost. For large-volume solutions, ASICs are a no-brainer. The lengthier development process and upfront costs can be amortized over a large number of units that have low per-unit cost. Not to mention the improvements in performance, area, and power. However, FPGAs may be more cost effective if the number of units if their performance is sufficient, and the expected number of units is relatively small.

FPGAs are also common in ASIC design as they make for great prototyping tools; they are as close to getting the design in silicon as possible without literally sending the design to the fab. Because FPGAs can emulate the design faster than software simulators, they can be used to accelerate the verification process. They can also be used by the software team to emulate the chip while they wait for the silicon from the fab.