# TODO:
# - proper positive/negative logic for arc construction. Current code assumes positive
# - add @assert that r can also be computed with norm(p2 - center) and it should be the same value as using p1
# - get_circle_center should return both centers and then we can choose which one to use (or maybe just return the one that is closest to the origin?)
"""
    struct Circle{T}

A circle defined by its center and radius.
"""
struct Circle{T} <: AbstractCurve{T}
    radius::T
    center::Point{T}
end

# Convenience constructor
Circle(center::Point, r::Real) = Circle{Float64}(r, center)

"Can also be constructed with three points on the circle"
function Circle(p1::Point, p2::Point, p3::Point)
    A = [p1[1] p1[2] 1;
         p2[1] p2[2] 1;
         p3[1] p3[2] 1]

    B = map(x -> dot(x,x), [p1, p2, p3])

    det(A) == 0 && error("circle not unique: points are collinear")
    X = A\B

    center = -0.5*Point(X[1], X[2])
    r = norm(p1 - center)

    return center, r
end

# Convenience constructor
Circle(p1::Tuple, p2::Tuple, p3::Tuple) = Circle(Point(p1), Point(p2), Point(p3))

"""
    (c::Circle)(t)

Evaluate the circle at parameter `t` in [0, 1].
"""
function (c::Circle)(t)
    sinθ, cosθ = sincos(2π*t)
    x = c.center[1] + c.radius*cosθ
    y = c.center[2] + c.radius*sinθ

    return Point(x, y)
end

"""
    struct CircularArc{T}

A circular arc starting at point `point[1]` and ending at point `point[2]`, with associated circle centered at `center` with radius `radius`.

# Arguments:
- `points::Vector{Point}`: The two points defining the arc.
- `center::Point`: The center of the associated circle.
- `radius::T`: The radius of the circle.
- `θ1::T`: The angle of the first point.
- `θ2::T`: The angle of the second point.
- `Δθ::T`: Angle difference Δθ = θ2 - θ1.
"""
struct CircularArc{T} <: AbstractCurve{T}
    points::Vector{Point{T}}
    center::Point{T}
    radius::T
    θ1::T
    θ2::T
    Δθ::T
end

# TODO: my swapping construction indeed fails. To be changed
"Constructor for CircularArc given two points and the center"
function CircularArc(p1::Point, p2::Point, center::Point; positive=true)
    # maybe calling it with swapped p1 and p2 if !positive will mess up the composite domains, as we'll need to specify p1 and p2 connected to the other curves/shapes on the domain
    !positive && return CircularArc(p2, p1, center)
    r = norm(p1 - center)
    θ1 = atan(p1[2] - center[2], p1[1] - center[1])
    θ2 = atan(p2[2] - center[2], p2[1] - center[1])
    θ1 = mod(θ1, 2π)
    θ2 = mod(θ2, 2π)

    # Ensure that θ2 > θ1 (for positive orientation)
    θ2 < θ1 && (θ2 += 2π)

    Δθ = θ2 - θ1
    points = [p1, p2]

    return CircularArc(points, center, r, θ1, θ2, Δθ)
end

"Constructor for CircularArc given two points and the radius"
function CircularArc(p1::Point, p2::Point, r::Real)
    center = get_circle_center(p1, p2, r)

    return CircularArc(p1, p2, center)
end

# Compute the center of the circle given 2 points and the radius
function get_circle_center(p1::Point, p2::Point, r::Real)
    dist = norm(p1 - p2)
    dist > 2r && error("No circle with given radius can pass through both points")

    # midpoint between points
    midpoint = (p1 + p2)/2

    # Distance from the midpoint to the center of the circle
    h = sqrt(r^2 - (dist/2)^2)

    # Vector perpendicular to the line segment p1 - p2
    direction = normalize(Point(-(p2.y - p1.y), p2.x - p1.x))

    center1 = midpoint + h*direction
    center2 = midpoint - h*direction

    return Point(center1)#, Point(center2)
end

"""
    (c::CircularArc)(t)

Evaluates the arc at point t
"""
function (c::CircularArc)(t)
    # if iszero(t)
    #     return c.p1
    # elseif isone(t)
    #     return c.p2
    # else
    θ = c.Δθ*t + c.θ1
    sinθ, cosθ = sincos(θ)
    x = c.center[1] + c.radius*cosθ
    y = c.center[2] + c.radius*sinθ

    return Point(x, y)
end