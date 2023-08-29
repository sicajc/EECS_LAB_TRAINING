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
