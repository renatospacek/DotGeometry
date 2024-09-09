"""
    Segment(p₁, p₂)
    Segment((x₁, y₁), (x₂, y₂))

Line segment connecting two points `p1` and `p2`.
"""
struct Segment{T} <: AbstractCurve{T}
    points::SVector{2,Point{T}}
end

# Convenience constructors
Segment(p1::Point, p2::Point) = Segment(SVector(p1, p2))
Segment(t1::Tuple, t2::Tuple) = Segment(Point(t1), Point(t2))
Segment(points::AbstractVector{<:Point}) = Segment(SVector(points...))
Segment(tuples::AbstractVector{<:Tuple}) = Segment(SVector{2,Point}(Point.(tuples)))

"""
    (l::Segment)(t)

Evaluate the line segment `s` at parameter `t` in [0,1].
"""
function (s::Segment)(t)
    (t < 0 || t > 1) && throw(DomainError(t, "t must be defined in [0, 1]."))
    return t*(s.points[2] - s.points[1]) + s.points[1]
end

Base.:(==)(s₁::Segment, s₂::Segment) = s₁.points == s₂.points

"""
    segments(c)

Split an polygonal chain `c` into the line segments connecting consecutive vertices.
"""
function segments(c::AbstractChain)
    ps = c.points
    n = length(ps) - !isclosed(c)

    return [Segment(ps[i], ps[i + 1]) for i in 1:n]
end

# temporary cheat for easier composite domain building
segments(c::AbstractCurve) = [c]

# some abuse of notation here using isclosed for points
function segments(ps::AbstractVector{<:Point})
    n = length(ps) - !isclosed(ps)

    return [Segment(ps[i], ps[i + 1]) for i in 1:n]
end

