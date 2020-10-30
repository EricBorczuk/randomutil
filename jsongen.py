import sys
import json
import random
import string


def randomstring(length):
    x = ''
    for i in range(0, length):
        x += random.choice(string.ascii_uppercase + string.digits)
    return x

if len(sys.argv) != 4:
    print("Usage: python jsongen.py [fieldlength] [fieldcount] [recordcount]")
    exit(1)

field_length = int(sys.argv[1])
field_count = int(sys.argv[2])
record_count = int(sys.argv[3])

for rec_i in range(0, record_count):
    data = {}
    for field_i in range(0, field_count):
        data[randomstring(field_length)] = randomstring(field_length)
    print(json.dumps(data))