from UnitConverter import UnitConverter
Pout_air = UnitConverter("2 W", 50)
print(Pout_air.W, Pout_air.dBm)

Pout_Rx_airt = UnitConverter("-31 dBuV", 50)
print(Pout_Rx_airt.W, Pout_Rx_airt.dBm)

Pout_air = UnitConverter("20 mW", 50)
print(Pout_air.W, Pout_air.dBm)

Pout_Rx_airt = UnitConverter("-31 dBm", 50)
print(Pout_Rx_airt.W, Pout_Rx_airt.dBm)