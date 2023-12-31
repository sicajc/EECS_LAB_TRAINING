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

## Thoughts about AXI and APB or AHB
- Think of them as a port for sending and receiving the data.
## Simply think of them as fast express,  normal express, slow express
- If you want to send a package(Master Write) to someone, you must first give the address(addr) and the package(data) to the postal clerk at the post office. Then the postal clerk will give the VALID pacakge to the postman, giving the postman the address you want to send.
- The postman would come to the specified address, and wait for the receiver to be READY for receiving the data.
- The receive would give the receiptent to the postman, the postman would send the receipent back to the post office. Then post office would send it back to you.

## AXI implementation details

<p align="center">
  <img src="./AXI-STREAM-RULE.jpg" width="500" heigh ="500">
</p>

1. You should seperate the WRITE FSM for write transactions and READ FSM for read transactions of the AXI master.
2. WRITE and READ ports can be accessed independently! By different circuit components.
3. Redeclaration and connect the outer world interfaces using registers within to prevent contamination issue.
4. Write and read these registers with your main design block.
5. Note for a SUCCESS transaction, VALID and READY must be both 1.
6. Abstraction and interface in verilog, though tedious, works as a powerful tool.
7. Can modularize DRAM access and DRAM read into different blocks, send an address in,the gets data out.
8. Cache controller must be implemented if you want to improve performance when access lots of data in DRAM.
9. When the same bus has 2 different part, you had better redclare the bus and connect for better debug experience.


## Fast prototyping and implementation
1. Choose multi-cycle machine first, finish coding it out, at least having a baseline model, then you can try other design choice.

2. Pipelined architecture would require you to seperate AXI_READ and AXI_WRITE into 2 controller.

3. AXI_READ and AXI_WRITE services can be seperated into different modules and test independently to make the code simpler and cleaner.


## MultiCycle architecture with AXI-4
- We simply replace the READ_DATA state and WB state with AXI steps of AXI protocals.

<p align="center">
  <img src="./MultiCycle_AXI.jpg" width="500" heigh ="500">
</p>

## Parrallel AXI-4 protocal
- Build independent controllers for Write Channel and Read channel, connects only the necessary inputs and outputs to each controllers.

- ASMD is within the PDF.

# Refernces
1. [RTL Design Example of APB](https://www.youtube.com/watch?v=ZtM4H8OCWDI&t=1441s)
2. [Notion notes](https://www.notion.so/06582258d7f845bc94b2a0919d011789?v=7b865b48469b4ef2b909d6cd4ceeb4a0&p=3c7f403061c247e5af8b6d6a57572edc&pm=s)
3. [IC_LAB_MIDTERM](https://github.com/mirkat1206/2021_Spring_NCTU_ICLAB/tree/main/Midterm_Project)
4. [SOC-101 Bus architecture](https://www.youtube.com/watch?v=EZrl33ZeOKI&list=PLZU5hLL_713ygweO3b_9KiZUJuEI7I5yK&t=456s)
