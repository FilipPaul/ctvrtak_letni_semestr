<h1>Python code for CBC</h1>

```python
def formatInputs(num)->str:
    """this function formats input number (in this example 4) into the following string:
    (DEC:4, BIN:0100)"""
    return f"(DEC:{num}, BIN:{bin(num)[2:].zfill(4)})"

message_blocks = [13,4,9] #input message blocks
table_output = [4,10,9,2,13,8,0,14,6,11,1,12,7,15,5,3] #Encryption substitution table
initial_vector = 6 #IV

########################## ENCRYPTION##########################################
output_cryptograms_list = [] #help variable to store cryptograms
input_encryption_list = [] #help variable to store inputs for encryption function (output of XOR)
i = 0
for blocks in message_blocks: #for each message block
    if i == 0:#first XOR has one input in form of initial vector, therfore this condition..
        print(f"xor_{i+1}: init_vect{formatInputs(initial_vector)} XOR Z_{i}{formatInputs(blocks)}")
        input_encryption_list.append(blocks^initial_vector)#output of XOR

    else:
        print(f"xor_{i+1}: init_vect{formatInputs(output_cryptograms_list[-1])} XOR Z_{i}{formatInputs(blocks)}")
        input_encryption_list.append(blocks^output_cryptograms_list[-1])#output of XOR

    print(f"Encription_input_{i+1}: {formatInputs(input_encryption_list[-1])}")
    #XOR output serves as pointer to the item of encryption table_output list
    output_cryptograms_list.append(table_output[input_encryption_list[-1]])
    print(f"Cryptogram_{i+1}: {formatInputs(output_cryptograms_list[-1])}")
    i+=1

########################## DECRYPTION ##########################################
i = 0
for cryptograms in output_cryptograms_list:
    print(f"Output of Dk_{i+1}: {formatInputs(table_output.index(cryptograms))}")
    if i == 0:
        print(f"Decrypted message block_{i+1}: {formatInputs(table_output.index(cryptograms)^initial_vector)}")
    else:
        print(f"Decrypted message block_{i+1}: {formatInputs(table_output.index(cryptograms)^output_cryptograms_list[i-1])}")
    i+=1
```

Output:\
xor_1: init_vect(DEC:6, BIN:0110) XOR Z_0(DEC:13, BIN:1101)\
Encription_input_1: (DEC:11, BIN:1011)\
Cryptogram_1: (DEC:12, BIN:1100)\
xor_2: init_vect(DEC:12, BIN:1100) XOR Z_1(DEC:4, BIN:0100)\
Encription_input_2: (DEC:8, BIN:1000)\
Cryptogram_2: (DEC:6, BIN:0110)\
xor_3: init_vect(DEC:6, BIN:0110) XOR Z_2(DEC:9, BIN:1001)\
Encription_input_3: (DEC:15, BIN:1111)\
Cryptogram_3: (DEC:3, BIN:0011)\
Output of Dk_1: (DEC:11, BIN:1011)\
Decrypted message block_1: (DEC:13, BIN:1101)\
Output of Dk_2: (DEC:8, BIN:1000)\
Decrypted message block_2: (DEC:4, BIN:0100)\
Output of Dk_3: (DEC:15, BIN:1111)\
Decrypted message block_3: (DEC:9, BIN:1001)
<br>
<h1>HMAC</h1>

```python
message_blocks = [13,4,9] #input message blocks
seal_key =7 
Constatnt_C1 = 13
Constatnt_C2 = 8
block_size = 4 #constants are 4 bit long.. 13 = 0b1101

def hashFunction(input):
    a = 11#constant
    t = int(len(input)/4) #count of blocks with length 4bits
    sum_result = 0 #variable to sum
    for i in range(t): #for each block
        for x in range(4):#for each bit in block of length 4
            sum_result += pow(a,i)*input[x+4*i]
    result = sum_result%17 #modulo 17
    return result

K_1 = Constatnt_C1^seal_key #XOR key with constant to get new keys
K_2 = Constatnt_C2^seal_key #XOR key with constant to get new keys

#K_1_list in for of [MSB, , ,LSB]
K_1_list_of_bits =  [int(i) for i in bin(K_1)[2:].zfill(4)]
#EXTEND message blocks to the K1 key
for blocks in message_blocks:
    message_list_of_bits = [int(i) for i in bin(blocks)[2:].zfill(4)]
    K_1_list_of_bits.extend(message_list_of_bits)

h_1 = hashFunction(K_1_list_of_bits) #HASH K1|Z(0)|Z(1)|Z(2)

#create blocks in form of K2|h1
h_1_list =  [int(i) for i in bin(h_1)[2:].zfill(4)]
K_2_list_of_bits =  [int(i) for i in bin(K_2)[2:].zfill(4)]
K_2_list_of_bits.extend(h_1_list)


h2 = hashFunction(K_2_list_of_bits) #HASH K2|h1

print(f"K1: (DEC:{K_1}, BIN: {bin(K_1)[2:].zfill(4)})")
print(f"K2: (DEC:{K_2}, BIN: {bin(K_2)[2:].zfill(4)})")
print(f"h1: (DEC:{h_1}, BIN: {bin(h_1)[2:].zfill(4)})")
print(f"h2: (DEC:{h2}, BIN: {bin(h2)[2:].zfill(4)})")
```

Output:\
K1: (DEC:10, BIN: 1010)\
K2: (DEC:15, BIN: 1111)\
h1: (DEC:13, BIN: 1101)\
h2: (DEC:3, BIN: 0011)