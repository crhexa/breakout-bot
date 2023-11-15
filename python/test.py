import sys, struct
import numpy as np


def read_float() -> float:
    return struct.unpack('<f', sys.stdin.buffer.read(4))[0]


def read_features(n_features : int):
    bytes = sys.stdin.buffer.read(4*n_features)
    data = np.empty(n_features)
    
    for i in range(n_features):
        j = 4*i
        data[i] = struct.unpack('<f', bytes[j : j+4])[0]

    return data

i = 0
while(i < 10):
    print(read_features(5), flush=True)
    i += 1