import random


# Run an xor chain on a given binary string with a given boolean key
def xor_chain(abyte="00000000", len=8, key=False):
	bytelist = list(abyte)
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


# Generate random byte
rbyte = random.randint(0,255)

# format as binary string for output
rbyte_str = "{0:08b}".format(rbyte)

print("byte is: '" + str(rbyte) + "', binary is: " + rbyte_str + "\n")

print("output: " + str(xor_chain(rbyte_str)))
