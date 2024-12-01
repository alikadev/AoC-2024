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

left.sort()
right.sort()


sum = 0
for i in range(len(left)):
    sum += abs(left[i] - right[i])

print(sum)

