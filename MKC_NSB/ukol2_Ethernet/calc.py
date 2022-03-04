from frames import first_frame, second_frame
frames = [first_frame, second_frame]

def parseMAC(MAC_frame):
    MAC_str = ""
    for byte,i in zip(MAC_frame,range(len(MAC_frame))):
        if i == 0:
            individual_group = byte & 1
            global_local = (byte & 0b10) >> 1
            if individual_group == 1:
                individual_group = "group"
            elif individual_group == 0:
                individual_group = "individual" 
            if global_local == 1:
                global_local = "local"
            elif global_local == 0:
                global_local = "global"
            print(f"first byte: 0x{byte:02X} -> 0b{bin(byte)[2:].zfill(8)} ->{individual_group} and {global_local} adress.\nMAC: ",end = "")

        MAC_str += f"{byte:02X}:"
    print(f"{MAC_str[:-1]} -> Vendor specific part: {MAC_str[0:8]}")

for fr, i in zip(frames, range(len(frames))):

    print(f"\n\nFRAME {i+1}:")
    dest_addr = fr[0:6]
    src_addr = fr[6:6+6]
    length_type = fr[12: 12+2]
    payload = fr[14:]

    print("Destination address:")
    parseMAC(dest_addr)

    print("\nSource address:")
    parseMAC(src_addr)

    print(f"\nlengt/type: 0x{length_type[0]:02X}{length_type[1]:02X} -> DEC: ", end = '')
    len_type_value = int(f"{length_type[0]:02X}{length_type[1]:02X}",16)
    if len_type_value < 1536:
        print(f"Value is smaller than DEC: 1536 -> lenght of payload is: {len_type_value} bytes")
    else:
        #Common eth_type values:
        if len_type_value == 0x800:
            eth_type = "IPv4"
        elif len_type_value == 0x86DD:
            eth_type = "IPv6"
        elif len_type_value == 0x806:
            eth_type = "ARP"
        elif len_type_value == 0x811:
            eth_type = "VLAN"

        print(f"Value is bigger than DEC: 1536 -> Ethertype is: {eth_type}")
