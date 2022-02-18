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