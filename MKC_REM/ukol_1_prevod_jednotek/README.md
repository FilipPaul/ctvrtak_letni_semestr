# Python code for units conversion
```python
import numpy as np
from engineering_notation import EngNumber

to_eng = EngNumber #eng notation e-6 -> u
#dummy spec chars to fstring
bck_sl = '\\' 
nl = 2*bck_sl + '\n'
c_left = '{'
c_right = '}'

imp = 50 #input impedance
power = [1,2,5e-6] #input Power values
voltage = [10,20,100e-3] #input Voltage values

#calculations
P_to_dDm = [10*np.log10(P/1e-3) for P in power]
P_to_dBuV = [20*np.log10(np.sqrt(P*imp)/1e-6) for P in power]
V_to_dBuV = [20*np.log10(V/1e-6) for V in voltage]
V_to_dBm = [10*np.log10( (V**2) / (50*1e-3) ) for V in voltage]

#format output into LATEX
print(f"""{bck_sl}textbf {c_left}Převod výkon ${bck_sl}rightarrow$ dBm:{c_right}{nl}{''.join(f'${to_eng(P_W)}W {bck_sl}rightarrow {P_dBm:.2f}dBm$ {nl}'
     for P_dBm,P_W in zip(P_to_dDm, power))}""".replace('u','\\mu '))

print(f"""{bck_sl}textbf {c_left}Převod výkon ${bck_sl}rightarrow$ dB$u$V:{c_right}{nl}{''.join(f'${to_eng(P_W)}W {bck_sl}rightarrow {P_dBuV:.2f}dBuV$ {nl}'
     for P_dBuV,P_W in zip(P_to_dBuV, power))}""".replace('u','\\mu '))

print(f"""{bck_sl}textbf {c_left} Převod napětí ${bck_sl}rightarrow$ dB$u$V:{c_right}{nl}{''.join(f'${to_eng(V_V)}V {bck_sl}rightarrow {V_dBuV:.2f}dBuV$ {nl}'
     for V_dBuV,V_V in zip(V_to_dBuV, voltage))}""".replace('u','\\mu '))

print(f"""{bck_sl}textbf {c_left}Převod napětí ${bck_sl}rightarrow$ dBm:{c_right}{nl}{''.join(f'${to_eng(V_V)}V {bck_sl}rightarrow {V_dBm:.2f}dBm$ {nl}'
     for V_dBm,V_V in zip(V_to_dBm, voltage))}""".replace('u','\\mu '))
```
OUTPUT:\
1_prevod_jednotek/calc.py\
\textbf {Převod výkon $\rightarrow$ dBm:}\\\
$1W \rightarrow 30.00dBm$ \\\
$2W \rightarrow 33.01dBm$ \\\
$5\mu W \rightarrow -23.01dBm$ \\\
\
\textbf {Převod výkon $\rightarrow$ dB$\mu $V:}\\\
$1W \rightarrow 136.99dB\mu V$ \\\
$2W \rightarrow 140.00dB\mu V$ \\\
$5\mu W \rightarrow 83.98dB\mu V$ \\\
\
\textbf { Převod napětí $\rightarrow$ dB$\mu $V:}\\\
$10V \rightarrow 140.00dB\mu V$ \\\
$20V \rightarrow 146.02dB\mu V$ \\\
$100mV \rightarrow 100.00dB\mu V$ \\\
\
\textbf {Převod napětí $\rightarrow$ dBm:}\\\
$10V \rightarrow 33.01dBm$ \\\
$20V \rightarrow 39.03dBm$ \\\
$100mV \rightarrow -6.99dBm$ \\\