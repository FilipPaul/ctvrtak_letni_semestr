<h1>Python code for CBC</h1>

```python
    def formatInputs(num)->str:
        return f"(DEC:{num}, BIN:{bin(num)[2:].zfill(4)})"

    message_blocks = [13,4,9]
    table_output = [4,10,9,2,13,8,0,14,6,11,1,12,7,15,5,3]
    initial_vector = 6

    output_cryptograms_list = []
    input_encryption_list = []
    i = 0
    for blocks in message_blocks:

        if i == 0:
            print(f"xor_{i+1}: init_vect{formatInputs(initial_vector)} XOR Z_{i}{formatInputs(blocks)}")
            input_encryption_list.append(blocks^initial_vector)

        else:
            print(f"xor_{i+1}: init_vect{formatInputs(output_cryptograms_list[-1])} XOR Z_{i}{formatInputs(blocks)}")
            input_encryption_list.append(blocks^output_cryptograms_list[-1])

        print(f"Encription_output_{i+1}: {formatInputs(input_encryption_list[-1])}")
        output_cryptograms_list.append(table_output[input_encryption_list[-1]])
        print(f"Cryptogram_{i+1}: {formatInputs(output_cryptograms_list[-1])}")
        i+=1
```

Output:
xor_1: init_vect(DEC:6, BIN:0110) XOR Z_0(DEC:13, BIN:1101)\
Encription_output_1: (DEC:11, BIN:1011)\
Cryptogram_2: (DEC:12, BIN:1100)\
xor_2: init_vect(DEC:12, BIN:1100) XOR Z_1(DEC:4, BIN:0100)\
Encription_output_2: (DEC:8, BIN:1000)\
Cryptogram_2: (DEC:6, BIN:0110)\
xor_3: init_vect(DEC:6, BIN:0110) XOR Z_2(DEC:9, BIN:1001)\
Encription_output_3: (DEC:15, BIN:1111)\
Cryptogram_2: (DEC:3, BIN:0011)\
decimal:15 BIN:1111