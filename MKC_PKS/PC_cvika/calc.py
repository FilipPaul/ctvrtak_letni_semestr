class IPAdress():
    def __init__(self,ipaddr:str):
        self.ipaddr = ipaddr
        self.IP = ipaddr[:ipaddr.find("/")]
        self.IP_bits = self.get_IP_bits(ipaddr)
        self.subnet_mask, self.subnet_mask_bits, self.suffix = self.get_subnet_mask(ipaddr)
        self.broadcast = ""
        self.network = ""
        self.host_min = ""
        self.host_max = ""
        self.host_count = ""
        self.get_IP_range()
        self.printInfo()

    def get_subnet_mask(self,ipaddr):
        pos = ipaddr.find("/")
        print(ipaddr[pos])
        subnet = "1"* int(ipaddr[pos+1:]) + "0"*(32-int(ipaddr[pos+1:]))
        mask = ""
        mask_bits = ""
        for Bytes in range(0,31,8):
            mask +=   f"{int(subnet[ Bytes: Bytes+8], 2)}."
            mask_bits += f"{subnet[ Bytes: Bytes+8]}."
            
        return mask[:-1],mask_bits[:-1], int(ipaddr[pos+1:]) #remove last dot

    def get_IP_bits(self,ipaddr):
        ipaddr = ipaddr[:ipaddr.find("/")]

        IP_bits = ""
        for Bytes in ipaddr.split("."):
            IP_bits += f"{bin(int(Bytes))[2:].zfill(8)}."
        return IP_bits[:-1] #remove last dot

    def get_IP_range(self):
        current_IP_bytes = self.IP_bits.split(".")
        current_SUBNET_bytes = self.subnet_mask_bits.split(".")
        
        for IP_Byte,MASK_Byte in zip(current_IP_bytes,current_SUBNET_bytes):
            i = 0
            network_substract = 0
            broadcast_to_add = 0
            for IP_BIT,MASK_BIT in zip(IP_Byte,MASK_Byte):
                if MASK_BIT == "0":
                    broadcast_to_add += 2**(7-i)
                if MASK_BIT == "0" and IP_BIT == "1":
                    network_substract += 2**(7-i)
                i+=1

            self.broadcast += f"{int(IP_Byte,2)+broadcast_to_add-network_substract}."
            self.network += f"{int(IP_Byte,2) - network_substract}."
            

        
        self.broadcast = self.broadcast[:-1]
        self.network = self.network[:-1]
        last_byte_pos= self.broadcast.rfind(".")
        self.host_max = self.broadcast[:last_byte_pos+1] + f"{int(self.broadcast.split('.')[-1])-1}"
        last_byte_pos= self.IP.rfind(".")
        self.host_min = self.network[:last_byte_pos+1] + f"{int(self.network.split('.')[-1])+1}"
        self.host_count = 2**(32-self.suffix) - 2

    def printInfo(self):
        print("IP Address full format:", self.ipaddr)
        print("IP:", self.IP)
        print("IP Bits:", self.IP_bits)
        print("Subnet Mask:", self.subnet_mask, "suffix:", self.suffix)
        print("Subnet Mask Bits:", self.subnet_mask_bits)
        print("\nNetwork:", self.network, "/", self.suffix)
        print("Broadcast:", self.broadcast)
        print("Host Min:", self.host_min)
        print("Host Max:", self.host_max)
        print("Host Count:", self.host_count)
    

IP = IPAdress("10.78.128.0/22")
IP = IPAdress("11.25.1.14/25")