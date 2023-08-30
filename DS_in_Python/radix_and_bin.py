num1 = 0x04
num2 = 0x20

print(f"The num is:{num1}")

num1_bin = f'{num1:08b}'
print(f"The num in 8 bit binary format:{num1_bin}")

num2_bin = f'{num2:08b}'
print(f"The num in 8 bit binary format:{num2_bin}")

num3_bin = num1_bin + num2_bin
print(f"Concat of num1_bin || num2_bin in binary is : {num3_bin}")

num3_dec = int(num3_bin,2)
print(f"Num3 in decimal is : {num3_dec}")

num3_hex = f'{num3_dec:04x}'
print(f"Num3 in hex is : {num3_hex}")

num3_hex_to_dec = int(num3_hex,16)
print(f"Num3 from hex in decimal is : {num3_hex_to_dec}")

extracted_num3_hex = num3_hex[0:2]
print(f"num3[0:1] is {extracted_num3_hex}")

extracted_num3_hex = num3_hex[2:4]
print(f"num3[2:3] is {extracted_num3_hex}")
