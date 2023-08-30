# AMBA notes
## Bus architecture
### Typical bus consists of 5 main components
1. Slave
2. Master
3. Decoder
4. Bridge
5. Arbiter

- With these operations in mind, Master commands the slave to do something. Master commands through the MMIO using address to know which slave they are calling.
- Slave uses the decoder to know whether they are called upon or not.The slave would response after the operation is done.
- Each channel in APB or AXI has ready and valid signals.

## APB(Advanced Peripheral Bus)
- This is usually serves as a low performance off-chip connection bus.



# Plan
0. Create the pattern data for matrix multiplication and convolution.
1. Create the PATTERN.v file for APB transfer and golden data check.
2. Create a basic APB interface using verilog and run to check if the simulation and access is correct.
3. Create a basic AXI interface and run if the simulation and access is correct.
4. Combine the interfaces together into your design.
5. Start the main design of your matrix multiplication and convolution.
6. Connect your design with the interfaces.
7. Run the testbench and do the synthesis.

## DRAM Pattern data for matrix multiplication and convolution
- Learn how to deal with binary string literals. Converting for int to binary to hex.
- Beware of the instruction field an first write down what you actually want to do to speed up the process of development.
- Do analysis and compare for faster code development

## Create the pattern file for APB transfer





# Q&A
- Why isnt the address of the matrix byte addressable? That is the matrix may start from address 7?
