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
