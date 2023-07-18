# Designware and pipelining
- The use of designware IP must follow the usage

## Importance
- The IP file in ppt, use the command tocall out the pdf.
- If you use Designware, you should use clean command after each simultion.
```
./09_clean_up
```

## Type
- First instantiate IP and modules.

## HW
- Floating point units are needed for the HW.
- Sigmoid activation function and floating point IPs are needed for solving the HW.


## CNN
-

## Cycle time adjustment
- When adjusting clock cycle time, remember to adjust both 02_SYN tcl file CYCLE TIME and PATTERN CYCLETIME.

## Design
- If you want to test the clock cycle time of IP, instantiate the IP using another module, then synthesize it to test its extreme clock delay.
