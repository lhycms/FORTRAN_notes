import numpy as np
from scipy.io import FortranFile


file_path = "/data/home/liuhanyu/hyliu/pwmat_demo/dos/bpsiiofil100001"
#file_path = "/data/home/liuhanyu/hyliu/pwmat_demo/dos/IN.WG"


### REAL*4 -> np.float32
### REAL*8 -> np.float64



### Way 1.
#f = FortranFile( file_path, 'r' )
#print( f.read_reals( dtype=np.float64 ).shape )
#print( f.read_reals( dtype=np.float64 )[200: 400] )


### Way 2.
#with open(file_path, "r") as f:
#    for line in f:
#        print(line)


### Way 3.
import struct

# Open the file in binary mode
with open(file_path, 'rb') as f:
    # Read the first 4 bytes to determine the byte ordering
    byte_order = f.read(8)
    print(byte_order)
    if byte_order == b'\x44\x3a\x01\x00':
        # Big-endian byte ordering
        endian = '>'
    elif byte_order == b'\x00\x01\x3a\x44':
        # Little-endian byte ordering
        endian = '<'
    else:
        raise ValueError('Unknown byte ordering')
    
    # Read the array dimensions (assumes Fortran ordering)
    nx = struct.unpack(endian + 'i', f.read(8))[0]
    ny = struct.unpack(endian + 'i', f.read(8))[0]
    nz = struct.unpack(endian + 'i', f.read(8))[0]

    # Read the data as a 3D array of 64-bit floating-point numbers
    data = np.zeros((nx, ny, nz), dtype=np.float64)
    for i in range(nx):
        for j in range(ny):
            for k in range(nz):
                data[i, j, k] = struct.unpack(endian + 'd', f.read(8))[0]
