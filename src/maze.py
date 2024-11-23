from collections import deque

# Full memory content as specified in the decompiled code
MEM = [
    0x41327924f1b91fe820120120804b93f9248e3926010092082080000036fbefb8,
    0x8c4f3a002402480003238db6237239920124124120b1db1249271c6412092400,
    0x24904920be1b9249246fa082092492003238e493c6fc9900120804824b7e47e4,
    0xf9fb9ff9dc9804020920904b927ee49249da0804004920131c9230c30c499048,
    0x260920100904132493f7230df1904804120804c7e3fe7fe3e264020000000831,
    0x4000b7279ff93bee64100000820831f11bf1c93ce804920104800ced89e7718f,
    0x13feff7ff7ffe80080400,
]

def decode_mem(mem):
    """
    Decode the compact MEM representation into a full grid.
    Args:
        mem (list): MEM values representing obstacles in compressed format.
    Returns:
        list: Decoded grid where each position is 0 (open) or 1 (blocked).
    """
    grid_size = 1616
    grid = [0] * grid_size

    for p in range(grid_size):
        block_index = p // 256
        bit_position = p % 256
        if block_index < len(mem):
            grid[p] = (mem[block_index] >> bit_position) & 0x1
    print(''.join([str(g) for g in grid]))
    return grid

def bfs_find_path(grid, start, end):
    """
    Perform BFS to find the shortest path in the grid.
    Args:
        grid (list): Decoded grid where each position is 0 (open) or 1 (blocked).
        start (int): Starting position in the grid.
        end (int): Target position in the grid.
    Returns:
        list: Sequence of positions and moves to reach the target, or None if no path exists.
    """
    directions = [
        (-49, '77'),  # Move up
        (-1, '61'),   # Move left
        (1, '64'),    # Move right
        (49, '73'),   # Move down
        # (-49, 'w'),  # Move up
        # (-1, 'a'),   # Move left
        # (1, 'd'),    # Move right
        # (49, 's'),   # Move down
    ]

    queue = deque([(start, [start], [])])  # Each entry is (position, positions_path, moves_path)
    visited = set([start])

    while queue:
        position, positions_path, moves_path = queue.popleft()

        if position == end:
            return positions_path, moves_path  # Return the sequence of positions and moves

        for move, direction in directions:
            next_pos = position + move
            if next_pos < 0:
                next_pos += 2**256
            next_pos = next_pos % 1616
            if next_pos not in visited and grid[next_pos] == 0:  # Check if position is open
                visited.add(next_pos)
                queue.append((next_pos, positions_path + [next_pos], moves_path + [direction]))

    return None, None  # No path found

# Decode the memory into a grid
grid = decode_mem(MEM)

# Define start and end positions
start = 0x232
end = 0x64f

# Find the path using BFS
positions_path, moves_path = bfs_find_path(grid, start, end)

# Output the result
if positions_path:
    print("Path found:")
    print("Positions in the path:")
    for pos in positions_path:
        print(hex(pos))  # Print positions in hexadecimal
    print("\nMoves in the path:")
    print("".join(moves_path))  # Print the sequence of moves
else:
    print("No path exists.")
