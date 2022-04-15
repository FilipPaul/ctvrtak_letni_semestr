# calc.py (main)
```python
from UnitConverter import UnitConverter
f = [2400, 2450, 2500] #MHz
spekt_meas = ["-130 dBm" , "8 dBuV", "-92 dBm"]
spekt_noise = ["-23 dBuV" , "-20 dBuV" , "-28 dBuV"]
impedance = 50
AF = ["20 dBm", "14 dBm", "12 dBm"]

E = []
spekt_meas_converted = [] #dBm
spekt_noise_converted = [] #dBm
SNR = []
SIGNAL = []

for i in range(len(spekt_meas)):
     #convert noise and measured signals to uV
     conv_val_meas = UnitConverter(spekt_meas[i],impedance)
     spekt_meas_converted.append(f"{conv_val_meas.uV:.2f} uV")

     conv_val_noise = UnitConverter(spekt_noise[i],impedance)
     spekt_noise_converted.append(f"{conv_val_noise.uV:.2f} uV")

     #SNR = measured[dBm] - noise[dBm] -> dB
     SNR.append(f"{conv_val_meas.dBm - conv_val_noise.dBm :.2f} dB")

     #signal only =  measured[uV] - noise[uV] -> dBm
     conv_val_signal = UnitConverter(f"{conv_val_meas.uV - conv_val_noise.uV} uV",impedance)
     SIGNAL.append(f"{conv_val_signal.dBm:.2f} dBm")
     
     #E[dBV/m] = AF[dBm] + V[dBV]
     E.append(f"{int(AF[i][:2]) + conv_val_signal.dBm :.2f} dBV/m")

#Save outputs into file for automatic TEX table generator
with open("output2.txt","w") as f:
     f.writelines(f"{[x for x in spekt_meas_converted]}\n")
     f.writelines(f"{[x for x in spekt_noise_converted]}\n")
     f.writelines(f"{[x for x in SNR]}\n")
     f.writelines(f"{[x for x in SIGNAL]}\n")
     f.writelines(f"{[x for x in E]}\n")

```

# CONVERSION CLASS
```python
import numpy as np
class UnitConverter:
     #EX: UnitConverter("-130 dBm" ,"dBuV", 50) -> will output 106.98 dBuV
     def __init__(self,convert_from :str,input_impedance :int):
          self.conv_from = convert_from
          self.input_impedance = input_impedance

          self.Power = "not initialize"
          
          self.kW = "not initialize"
          self.W = "not initialize"
          self.mW = "not initialize"
          self.uW = "not initialize"

          self.dB = "not initialize"
          self.dBm = "not initialize"
          self.dBu = "not initialize"

          self.kV = "not initialize"
          self.V = "not initialize"
          self.mV = "not initialize"
          self.uV = "not initialize"

          self.dBV = "not initialize"
          self.dBmV = "not initialize"
          self.dBuV = "not initialize"

          self.recognize_input_type()
          self.convertAll()

     def convertAll(self):
          #POWER TO POWER:
          self.kW = self.Power*1e-3
          self.W = self.Power
          self.mW = self.Power*1e3
          self.uW = self.Power*1e6

          #POWER TO POWER DB
          self.dB = 10*np.log10(self.Power)
          self.dBm = 10*np.log10(self.Power/1e-3)
          self.dBu = 10*np.log10(self.Power/1e-6)

          #POWER TO VOLTAGE
          self.V = np.sqrt(self.Power * self.input_impedance) 
          self.kV = self.V*1e-3 
          self.mV = self.V*1e3 
          self.uV = self.V*1e6 

          #POWER TO VOLTAGE DB
          self.dBV = 20*np.log10(self.V)
          self.dBmV = 20*np.log10(self.V/1e-3)
          self.dBuV = 20*np.log10(self.V/1e-6)
     
     def printAll(self):
          print(f"CONVERTING: {self.conv_from:} at ZIN: {self.input_impedance} to:")
          print(f"POWER:\n {self.kW: .3f}kW {self.W: .3f}W {self.mW: .3f}mW {self.uW: .3f}uW")
          print(f"POWER in dB:\n {self.dB: .3f}dB {self.dBm: .3f}dBm {self.dBu: .3f}dBu")
          print(f"VOLTAGE:\n {self.kV: .3f}kV {self.V: .3f}V {self.mV: .3f}mV {self.uV: .3f}uV")
          print(f"VOLTAGE in dB:\n {self.dBV: .3f}dBV {self.dBmV: .3f}dBmV {self.dBuV: .3f}dBuV")

     def recognize_input_type(self):
          #recognizes input type and convert all possible inputs to power in Wats
          #all folowing conversions will be related to P in WATS
          val,unit = self.conv_from.split(" ")
          val = float(val)
          #POWER in dB
          if unit == "dB":
               self.Power = 10**(val/10)
          elif unit == "dBm":
               self.Power = 10**(val/10)*1e-3
          elif unit == "dBu":
               self.Power = 10**(val/10)*1e-6

          #POWER

          elif unit == "kW":
               self.Power = val*1e3
          elif unit == "W":
               self.Power = val
          elif unit == "mW":
               self.Power = val*1e-3
          elif unit == "uW":
               self.Power = val*1e-6

          #VOLTAGE IN DB
          elif unit == "dBV":
               V = 10**(val/20)
               self.Power = V**2/self.input_impedance
          elif unit == "dBmV":
               V = 10**(val/20)*1e-3
               self.Power = V**2/self.input_impedance
          elif unit == "dBuV":
               V = 10**(val/20)*1e-6
               self.Power = V**2/self.input_impedance

          #VOLTAGE
          elif unit == "kV":
               self.Power = (val*1e3)**2/self.input_impedance
          elif unit == "V":
               self.Power = val**2/self.input_impedance
          elif unit == "mV":
               self.Power = (val*1e-3)**2/self.input_impedance
          elif unit == "uV":
               self.Power = (val*1e-6)**2/self.input_impedance

          else:
               print("unknown input parameter: supported units: dB dBm dBu kW W mW uW dBV dBmV dBuV kV V mV uV")
```