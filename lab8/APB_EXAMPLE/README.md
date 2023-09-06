## APB exercise
### Goal
- APB_ADD request DRAM's data in TB using a particular address, TB must throw the data to APB_ADD , the APB_ADD gets the data, add the data by 1 then send the data back to the address you just requested from DRAM. Do this for all address location from 0x1000 ~ 0x1fff

1. APB_ADD request DRAM's data in TB using a particular address
2. TB throws the data to APB_ADD using APB
3. APB_ADD receives the data
4. APB_ADD add the received data by 1
5. Stored the received data back to the same APB address.
6. Repeats until all the value of each address location in the DRAM is incremented by 1

## TB
1. Generate a TB with address space of 0x1000 ~ 0x1fff
2. Randomly assign value to the address space.

## Plan
1. Code the APB master using systemVerilog
2. Code the TB by refering the TB of ICLAB


## Thoughts about AXI and APB or AHB
- Think of them as a port for sending and receiving the data.
## Simply think of them as fast express,  normal express, slow express
- If you want to send a package(Master Write) to someone, you must first give the address(addr) and the package(data) to the postal clerk at the post office. Then the postal clerk will give the VALID pacakge to the postman, giving the postman the address you want to send.
- The postman would come to the specified address, and wait for the receiver to be READY for receiving the data.
- The receive would give the receiptent to the postman, the postman would send the receipent back to the post office. Then post office would send it back to you.