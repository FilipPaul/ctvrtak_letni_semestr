from myIPAdress import myIPAdress #import my custom class

print("\nK dispozici:")
myIPAdress("10.78.128.0/22").printInfo()

print("\nLAN 0")
myIPAdress("10.78.128.0/24").printInfo()

print("\nLAN 1")
myIPAdress("10.78.129.0/24").printInfo()

print("\nLAN 2")
myIPAdress("10.78.130.0/24").printInfo()

print("\nSUBNET 3")
myIPAdress("10.78.131.0/30").printInfo()

print("\nSUBNET 4")
myIPAdress("10.78.131.4/30").printInfo()

print("\nSUBNET 5")
myIPAdress("10.78.131.8/30").printInfo()