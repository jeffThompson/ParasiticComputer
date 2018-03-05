
'''
ZIP TO BYTE ARRAY
(aka the binary DNA encoder)
Jeff Thompson | 2018 | jeffreythompson.org

Create a C-style array of bytes from a 7z archive (higher
compression than ZIP), to be uploaded to an Arduino.

'''

import binascii
from pprint import pprint


# url = 'https://www.github.com/jeffthompson/parasiticcomputer'

# arr = 'const char url[] = {\n\t'
# i = 0
# for char in url:
# 	bits = [bin(ord(c))[2:].zfill(8) for c in char][0]
# 	for bit in bits:
# 		arr += bit + ', '
# 		i += 1
# 		if i % 30 == 0:
# 			arr += '\n\t'
# arr = arr[:-2] + '\n};'
# print arr

# ========================================================

# # load binary data as a big string of hex values
with open('DNA.7z', 'rb') as f:
	hex_data = binascii.hexlify(f.read())

# convert to a list in pairs
hex_list = map(''.join, zip(hex_data[::2], hex_data[1::2]))

all_bytes = {}
for pos, byte_string in enumerate(hex_list):
	byte_string = '0x' + byte_string
	if byte_string in all_bytes.keys():
		all_bytes[byte_string].append(pos)
	else:
		all_bytes[byte_string] = [ pos ]
pprint(all_bytes)

# make into ascii representations, as a C array
# dna = 'const unsigned char dna[] = {'	# declare array
# for i, b in enumerate(hex_list):
# 	if i % 10 == 0:						# add line-breaks every 10 bytes
# 		dna += '\n\t'
# 	dna += '0x' + b + ', '
# dna = dna[:-2]							# remove that last comma
# dna += '\n};'							# close array

# # calculate and add the data's checksum, to compare when extracting
# checksum = binascii.crc32(dna)
# dna = 'const long checksum = ' + str(checksum) + ';\n' + dna

# print 'num items: ' + str(len(dna))
# print 'checksum:  ' + str(checksum)

# # write to output file
# with open('DNA.h', 'w') as output:
	# output.write(dna)

