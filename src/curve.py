from fastecdsa.curve import Curve
from fastecdsa.point import Point
from fastecdsa.util import mod_sqrt

# Define the curve
curve = Curve(
    name='custom_curve',
    p=10815735905440749559,
    a=7355136236241731806,
    b=5612508011909152239,
    q=None,  # Order of the curve, not needed for this operation
    gx=None,  # Base point x-coordinate, not needed for this operation
    gy=None   # Base point y-coordinate, not needed for this operation
)

# Given x value
x_value = 1352982446166918000

# Calculate right-hand side of the curve equation
rhs = (x_value**3 + curve.a * x_value + curve.b) % curve.p

# Find y values using mod_sqrt
try:
    y1 = mod_sqrt(rhs, curve.p)
    if isinstance(y1, tuple):
        y1, y2 = y1
    else:
        y2 = (curve.p - y1) % curve.p
except ValueError:
    print("No valid y exists for the given x on the curve.")
    exit(1)

# Define the base point W0
W0 = Point(3382663674857988534, 1617325850231501001, curve=curve)

# Function to perform point subtraction
def point_subtract(p1, p2):
    # In elliptic curves, subtraction is adding the inverse point
    p2_inv = Point(p2.x, -p2.y % curve.p, curve=curve)
    if p1 == p2_inv:
        return Point.IDENTITY_ELEMENT  # Point at infinity
    else:
        return p1 + p2_inv

# Calculate and print the results
for y_value in [y1, y2]:
    p1 = Point(x_value, y_value, curve=curve)
    result = point_subtract(p1, W0)
    print(f"Point subtraction result for y = {y_value}: ({result.x}, {result.y})")
