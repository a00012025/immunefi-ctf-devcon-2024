from z3 import *

def is_prime_z3(n):
    if n <= 1:
        return False
    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False
    return True

def find_solution():
    x1 = 7590971729312603494
    y1 = 4025301139565492703
    target = 1352982446166918000
    INT64_MAX = 2**63 - 1
    INT64_MIN = -2**63

    # Define Z3 variables
    x2 = BitVec('x2', 64)
    y2 = BitVec('y2', 64)
    p = BitVec('p', 64)
    s = BitVec('s', 64)
    inv = BitVec('inv', 64)

    # Create a solver instance
    solver = Solver()

    # Add int64 range constraints
    solver.add(p > 2**63, p < 2**64)  # p must be in uint64
    solver.add(x2 >= INT64_MIN, x2 <= INT64_MAX)
    solver.add(y2 >= INT64_MIN, y2 <= INT64_MAX)
    solver.add(s >= INT64_MIN, s <= INT64_MAX)
    solver.add(inv >= INT64_MIN, inv <= INT64_MAX)

    # Ensure inv is the modular multiplicative inverse of (x1-x2)
    solver.add((x1 - x2) * inv % p == 1)
    
    # s = (y2-y1)/(x1-x2) mod p = (y2-y1) * inv mod p
    solver.add(s == ((y2 - y1) * inv) % p)
    
    # Add the main equation constraint
    solver.add((s * s - x1 - x2) % p == target)

    # Check for a solution
    if solver.check() == sat:
        model = solver.model()
        p_value = model[p].as_long()
        return model[x2].as_long(), model[y2].as_long(), p_value
    return None

solution = find_solution()
if solution:
    print(f"Found solution: x2={solution[0]}, y2={solution[1]}, p={solution[2]}")
else:
    print("No valid solution found.") 