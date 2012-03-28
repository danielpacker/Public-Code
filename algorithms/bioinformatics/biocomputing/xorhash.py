import random
import collections


# Run an xor chain on a given binary string with a given boolean key
def xor_chain(abyte="00000000", len=8, key=False):
	bytelist = list(abyte[::-1]) # reverse string for right->left
	hash = list()
	for i in range(len):
		print(bytelist[i])
		bit = bool(int(bytelist[i]))
		print("bit: " + str(bit))
		key = bit ^ key
		print("key: " + str(key))
		hash.append(str(int(key)))
	print("\n")
	return "".join(hash)

# convert byte (int from 0..255) to binary string
def byte_to_bin(rbyte=-1):
	# Generate random byte
	if (rbyte==-1):
		rbyte = random.randint(0,255)
	# format as binary string for output
	rbyte_str = "{0:08b}".format(rbyte)
	return rbyte_str

# make sure function is 1:1 for all bytes
keyvals = {}
for i in range(255):
	bstr = byte_to_bin(i)
	keyvals[bstr] = xor_chain(bstr)
c = collections.Counter(keyvals.values())
#print(keyvals)
numduplicates = len([i for i in c if c[i]>1])
numoriginals = len(keyvals.values())
print("number of originals: " + str(numoriginals) + " number of duplicates: " + str(numduplicates) + "\n")
