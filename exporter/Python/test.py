import decompress

data = ""

with open("C:/Users/user/Documents/Hyperspace/.baker/compressed.txt", "r", encoding="utf-8") as f:
	data = f.read()

result = decompress._decompress(data)

print(result)