def formatInputs(num)->str:
    """this function formats input number (in this example 4) into the following string:
    (DEC:4, BIN:0100)"""
    return f"(DEC:{num}, BIN:{bin(num)[2:].zfill(4)})"

message_blocks = [13,4,9] #input message blocks
table_output = [4,10,9,2,13,8,0,14,6,11,1,12,7,15,5,3] #Encryption substitution table
initial_vector = 6 #IV

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