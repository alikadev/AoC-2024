import sys

if len(sys.argv) != 2:
    print(f"Usage: {sys.argv[0]} <input.txt>")
    exit(1)


left = []
right = []

with open(sys.argv[1], "r") as f:
    for line in f:
        row = [int(s) for s in line.split() if s.isdigit]
        if len(row) != 2:
            continue # Skip
        left.append(row[0])
        right.append(row[1])

sum = 0
for value in left:
    sum += value * right.count(value)

print(sum)

