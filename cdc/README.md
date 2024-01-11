# Clock Domain Crossings (CDCs)
On a chip, it is not uncommon to have different components being clocked by independent clock signals. This could happen for a variety of reasons including (but not limited to) differences in timing requirements, and power consumption. The issue here is when we need to move data from one clock domain to another. Depending on the relationship between the source and destination clocks (or lack thereof), we encounter issues such as metastability and data loss. Additionally, the relationship between the source and destination clocks will define the solutions we have to deal with the CDC. [This EE Times article](https://www.eetimes.com/understanding-clock-domain-crossing-issues/) details different CDC issues and their possible solutions. I will also be referencing information from [this VLSI Universe blog post](https://vlsiuniverse.blogspot.com/2013/09/synchronization-schemes.html) which discusses different synchronization methods. As I do not have much experience with CDCs, I will focus mainly on explaining synchronizations methods in as simple terms as possible. 

## Flop Chaining (Synchronizer)
Flop chaining is the most simple of the synchronizers: we simply chain multiple flip-flops clocked in the destination domain. How long does this chain need to be? This depends on the setup and hold times of the flops, the clock frequencies, and the desired mean time before failure (MTBF). The longer the setup and hold times, and the greater the clock frequencies, the higher chance that metastability will occur, thereby lowering the MTBF. It appears that two flops is generally acceptable, but for high frequency operation, it is prudent to add an extra flip-flop. The VLSI Universe blog post also mentions that the MTBF decreases approximately linearly with the number of synchronizers in the system, so if there is a large amount of CDCs in the system, the synchronizers must be designed for a larger MTBF than the target.

The primary purpose of flop chaining is to insure against metastability (resulting from the sensitive edges occurring close together) from propagating. Only when the source domain's frequency is lower (at least twice as low) as the destination frequency, can we expect that data will make it across the CDC. If this is not the case, the source signal may not be held long enough to be captured by the destination flops, resulting in data loss. Additionally, flop chaining is not suitable for multi-bit signals as we cannot guarantee that all bits will arrive and be captured successfully on the same clock cycle. This makes flop chaining (on its own) a limited synchronization method, but its insurance against metastability makes it a crucial component in more advanced synchronization techniques.

## Mux Synchronizer
The mux synchronizer addresses the flop chain synchronizer's issue of not being able to transfer more than one data bit at a time. To send a multi-bit signal across the CDC, we assert the multi-bit signal across the CDC, plus an enable signal through a flop chain synchronizer. The end of the block chain synchronizer is used as an input select for muxes on each bit of the multi-bit signal. When the muxes do not receive the enable signal, they select signal the flops are receiving flops are currently holding, and when the muxes receive the enable signal, they select the signal coming across the CDC. In this way, we insure against the enable signal being metastable, and by the time the enable signal is received in the destination domain, the data signals should also be stable as well.

However, this method alone is limited to scenarios where the source domain naturally holds the multi-bit data signal long enough for the enable signal to make it through the flop chain and for the destination flops to capture the data.

## Handshaking
So what if we need to transfer a signal from a higher frequency domain to a lower frequency domain, or if we do not know the relationship between the frequencies or phases of the clock signals? The problem is we need to make sure the source domain holds the signal long enough for it to be captured by the destination domain. We can accomplish this by having the destination domain provide feedback to the source domain through a handshaking protocol. Handshaking requires two control signals: `req` originating from source domain to destination, and `ack` originating from destination domain to source domain. The following steps detail the handshaking process:

1. Source domain asserts `req`.
2. Upon observing `req`, destination domain asserts `ack`.
3. Upon observing `ack`, source domain clears `req`.
4. Upon observing `req` being cleared, destination domain clears `ack`.
5. Upon observing `ack` being cleared, only now can the source domain make another transfer.

Note that this protocol only solves the issue of holding the signal long enough for the destination to successfully capture it; it does not handle the issue of metastability when crossing the CDC. As such, both of these signals require a flop chain synchronizer when moving across the CDC.

There is additional benefit to this synchronization method as it enables movement of multi-bit signals across the CDC. We simply send the multi-bit signal across the CDC and use the `req` and `ack` as control signals to determine how long to hold the multi-bit signal. This works because the data is being held steady and the req flop chain basically ensures the data is stable by the time the destination domain observes the assertion of the `req` signal.

The downside of this synchronization method is that we have to wait for the control signals to propagate through the flop chain synchronizers (twice from source to destination, and twice from destination to source) just for one signal transfer. This takes a heavy toll on bandwidth and may not be suitable for high performance applications.

## Asynchronous FIFO
Asynchronous FIFOs are very common due to their ability to transfer multi-bit data across clock domains with minimal impact on bandwidth (as long as the buffer is sufficiently large, or writes are sufficiently infrequent). The implementation of the asynchronous FIFO is a bit more involved than just using a flop chain synchronizer, and deserves a lengthier explanation in the `fifo_async` directory.


