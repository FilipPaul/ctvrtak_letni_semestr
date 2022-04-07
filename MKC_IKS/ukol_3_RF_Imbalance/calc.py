FH = 7 #upper freq limit in MHz
FL = 5 #lower freq limit in MHz

print(f"Awaiable intervals for k:")
for k in range(1,int(FH/(FH-FL))+1): #k = 1,2,...,int(FH/BW)
    if k == 1: #devide by zero
        print(f"Interval for k = {k}; FS: ({2*FH/k} ; inf) MHz")
    else:
        print(f"Interval for k = {k}; FS: ({2*FH/k} ; {2*FL/(k-1)}) MHz")