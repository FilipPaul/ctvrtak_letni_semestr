

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
