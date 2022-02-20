# Python code for units conversion and table formating
```python
import numpy as np
import csv

def convert_dBuV_to_dBm(V_dBuV, imp = 50):
     """Give me dBuV and i will return dBm"""
     V = pow(10,(float(V_dBuV)/20))*1e-6
     P_dBm = 10*np.log10((V**2)/(imp*1e-3))
     return P_dBm

#load csv
with open('tabulky.csv', newline='') as f:
    reader = csv.reader(f)
    data = list(reader)
    data[0][0] = data[0][0][-2:]
    f.close()

#formating and converting dBuV to dBm
frequency = [f"{freq[0]}kHz" for freq in data]
power_dbm_a = [f"{P[1]}dBm" if P[2]=="dBm" else f"{convert_dBuV_to_dBm(P[1]):.2f}dBm" for P in data ]
power_dbm_b = [f"{P[3]}dBm" if P[4]=="dBm" else f"{convert_dBuV_to_dBm(P[3]):.2f}dBm" for P in data ]
result_dB = [f"{(float(power_dbm_a[i][:-3]) - float(power_dbm_b[i][:-3])):.2f}dB" for i in range(len(frequency))]

#final rows for new table
rows = [f"{frequency[i]},{power_dbm_a[i]},{power_dbm_b[i]},{result_dB[i]}\n" for i in range(len(frequency))]

#writing to csv file
with open("converted.csv", 'w') as f:
     for row in rows:
          f.write(row)
     f.close()     

```