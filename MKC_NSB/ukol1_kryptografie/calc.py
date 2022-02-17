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

def Encryption_function(message_Z, encrypt_key_Ke):
    """ C = E(Z,Ke), where C..cryptogram, E..Encryption function itself, Z..message, Ke..EncryptionKey"""
    cryptogram_C = "encrypted message"
    return cryptogram_C

def Decryption_function(cryptogram_C, decrypt_key_Kd):
    """ Z = D(C,Kd), where Z..decrypted (original) message, D..Decryption function itself, C..cryptogram, Kd..DecryptionKey"""
    message_Z = "original message"
    return message_Z


#Authentication Process

#Sealing
def Sealing_function(message_Z, sealing_key_Kp):
    seal_P = "Authentication SEAL"
    return seal_P

#verification
def Verification_function(message_Z,seal_P,authentication_key_Kv) -> bool:
    message_is_authentic = True
    return message_is_authentic
    

def Hash_function(source_message):
    hasehed_source_message = "#cđ968daˇ^~2Eđ&#x§&as" #hash has fixed length
    return hasehed_source_message
