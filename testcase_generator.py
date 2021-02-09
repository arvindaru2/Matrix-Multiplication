import csv
import mnist as mn
import random

ran = random.randrange(10**80)
myhex = "%064x" % ran


weight_hex = []
weight_val = []
a_hex = []
a_val = []

# testcase_generator creates 2 lists
# first list contains 8 8-bit numbers represented in hex (2-digits each)
# second list contains the decimal values of those numbers in 2's complement
def testcase_generator():
    m_hex = []
    m_val = []
    for i in range(0, 8):
        line_hex = []
        line_val = []
        for j in range (0, 8):
            b = random.randrange(0, 255)
            b_se = b + 256
            b_str = hex(b_se)
            weight_hex = b_str[3:5]
            if b > 127:
                b = b - 256
            line_hex.append(weight_hex)
            line_val.append(b)
        m_hex.append(line_hex)
        m_val.append(line_val)
    return (m_hex, m_val)


(weight_hex, weight_val) = testcase_generator()
(a_hex, a_val) = testcase_generator()

for i in range(0,8):
    print("b", end = "")
    print(" = 64'h", end = "")
    for j in range(0,8):
        print(weight_hex[i][j], end = "" )
    print (";")
    print("#2")

for i in range(0,8):
    print("a", end = "")
    print(" = 64'h", end = "")
    for j in range(0,8):
        print(a_hex[i][j], end = "" )
    print (";")
    print("#2")

all_values = []
for i in range(0,8):
    current_values = []
    for j in range(0,8):
        sum = 0;
        for k in range(0,8):
            sum = sum + a_val[i][k] * weight_val[j][k]
        current_values.append(sum)
    all_values.append(current_values)

print(all_values)