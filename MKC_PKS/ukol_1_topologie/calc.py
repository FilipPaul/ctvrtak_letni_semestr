from math import comb
sum = 0
N_total_users = 18
N_overflow = 11
for k in range(N_overflow,N_total_users):
    sum += comb(18,k)*pow(0.2,k)*pow(1-0.2,k)
output = f"{(sum*100):.4f}%"
print(output)

print(1e3*15000*1e3/(0.2*3*pow(10,8)) )