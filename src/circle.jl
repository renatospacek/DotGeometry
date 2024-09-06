# TODO:
# - if pt1 = pt2 then its a circle
# - add positive/negative as inputs. Current code assumes positive; if negative then call the same method with pt1 and pt2 swapped
# - maybe also write a method if given pt1, pt2 and r? (i.e. have to find center)
# - add @assert that r can also be computed with norm(p2 - center) and it should be the same value as using p1
# - get_circle_center should return both centers and then we can choose which one to use (or maybe just return the one that is closest to the origin)

"""
    struct Circle{T}

A circle defined by its center and radius.
"""
struct Circle{T} <: AbstractCurve{T}
    radius::T
    center::Point{T}
end


"Can also be constructed with three points on the circle"
function Circle(a::Point, b::Point, c::Point)
    A = [a[1] a[2] 1;
         b[1] b[2] 1;
         c[1] c[2] 1]

    B = map(x -> dot(x,x), [a, b, c])

    det(A) == 0 && error("circle not unique: points are collinear")
    X = A\B

    center = -0.5*Point(X[1], X[2])
    r = sqrt((X[1]^2 + X[2]^2)/4 - X[3])

    return center, r
end
# Convenience constructor
Circle(p1::Tuple, p2::Tuple, p3::Tuple) = Circle(Point(p1), Point(p2), Point(p3))

"""
    (c::Circle)(t)

Evaluate the circle at parameter `t` where `t` is in [0, 1].
"""
function (c::Circle)(t)
    sinθ, cosθ = sincos(2π*t)
    x = c.center[1] + c.radius*cosθ
    y = c.center[2] + c.radius*sinθ

    return Point(x, y)
end

"""
    struct CircularArc{T}

A circular arc starting at point `pt1` and ending at point `pt2`, with associated circle centered at `center` with radius `r`.
"""
struct CircularArc{T} <: AbstractCurve{T}
    points::Vector{Point{T}}
    center::Point{T}
    radius::T
    θ1::T
    θ2::T
    Δθ::T
end


"Constructor for CircularArc given two points and the center"
function CircularArc(pt1::Point, pt2::Point, center::Point; positive=true)
    # maybe calling it with swapped pt1 and pt2 if !positive will mess up the composite domains, as we'll need to specify pt1 and pt2 connected to the other curves/shapes on the domain
    !positive && return CircularArc(pt2, pt1, center)
    r = norm(pt1 - center)
    θ1 = atan(pt1[2] - center[2], pt1[1] - center[1])
    θ2 = atan(pt2[2] - center[2], pt2[1] - center[1])
    θ1 = mod(θ1, 2π)
    θ2 = mod(θ2, 2π)

    # Ensure that θ2 > θ1 (for positive orientation)
    θ2 < θ1 && (θ2 += 2π)

    Δθ = θ2 - θ1
    points = [pt1, pt2]

    return CircularArc(points, center, r, θ1, θ2, Δθ)
end

"Constructor for CircularArc given two points and the radius"
function CircularArc(p1::Point, p2::Point, r)
    center = get_circle_center(p1, p2, r)

    return CircularArc(p1, p2, center)
end
# %%
"Compute the center of the circle given 2 points and the radius"
function get_circle_center(p1, p2, r)
    x1, y1 = p1
    x2, y2 = p2

    mx, my = (x1 + x2)/2, (y1 + y2)/2

    d = sqrt((x2 - x1)^2 + (y2 - y1)^2)
    d > 2*r && error("No circle with given radius can pass through both points")

    h = sqrt(r^2 - (d/2)^2)

    dx = (y2 - y1)/d
    dy = (x2 - x1)/d

    center1 = [mx + h*dx, my - h*dy]
    center2 = [mx - h*dx, my + h*dy]

    return Point(center1)#, Point(center2)
end

"""
    (c::CircularArc)(t)

Evaluates the arc at point t
"""
function (c::CircularArc)(t)
    # if iszero(t)
    #     return c.pt1
    # elseif isone(t)
    #     return c.pt2
    # else
    θ = c.Δθ*t + c.θ1
    sinθ, cosθ = sincos(θ)
    x = c.center[1] + c.radius*cosθ
    y = c.center[2] + c.radius*sinθ
    return Point(x, y)
end


# function circ_coords(pt1::Point, pt2::Point, center::Point, t::Float64; positive=true)
#     !positive && return CircularArc(pt2, pt1, center)
#     r = norm(pt1 - center)
#     θ1 = atan(pt1[2] - center[2], pt1[1] - center[1])
#     θ2 = atan(pt2[2] - center[2], pt2[1] - center[1])
#     θ1 = mod(θ1, 2π)
#     θ2 = mod(θ2, 2π)

#     # Ensure that θ2 > θ1 (for positive orientation)
#     θ2 < θ1 && (θ2 += 2π)

#     Δθ = θ2 - θ1
#     points = [pt1, pt2]

#     θ = Δθ*t + θ1
#     sinθ, cosθ = sincos(θ)
#     x = center[1] + r*cosθ
#     y = center[2] + r*sinθ
#     return x,y
# end