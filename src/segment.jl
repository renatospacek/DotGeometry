"""
    struct Segment{T}

A line segment connecting two points `p1` and `p2`.
"""
struct Segment{T} <: AbstractCurve{T}
    points::SVector{2, Point{T}}
    # function Segment(points::SVector{2, <:Point})
    #     @assert length(points) == 2 "Segment requires exactly 2 points"
    #     p1, p2 = points
    #     new_points = SVector(promote_points(p1, p2))
    #     new{eltype(eltype(new_points))}(SVector(promote_points(p1, p2)))
    # end
end

"Constructors for Segment"
Segment(p1::P, p2::P) where {P<:Point} = Segment(SVector(p1, p2))
Segment(t1::T, t2::T) where {T<:Tuple} = Segment(Point(t1), Point(t2))
# Segment(points::AbstractVector{<:Point}) = length(points) == 2 ? Segment(SVector(points...)) : error("Segment requires exactly 2 points")
# Segment(tuples::AbstractVector{<:Tuple}) = length(tuples) == 2 ? Segment(Point{T}[tuples...]) : error("Segment requires exactly 2 tuples")
Segment(points::AbstractVector{<:Point}) = Segment(SVector(points...))
Segment(tuples::AbstractVector{<:Tuple}) = Segment(SVector(Point.(tuples)))
"""
    (l::Segment)(t)

Evaluate the line segment `l` at parameter `t`.
"""
function (l::Segment)(t)
    (t < 0 || t > 1) && throw(DomainError(t, "t must be defined in [0, 1]."))
    return t*(l.points[2] - l.points[1]) + l.points[1]
end

Base.:(==)(l₁::Segment, l₂::Segment) = l₁.p1 == l₂.p1 && l₁.p2 == l₂.p2

"""
    segments(c)

Splits an polygonal chain `c` into the line segments connecting consecutive vertices, returning an array of `Segment` objects.
"""
function segments(c::AbstractChain)
    ps = c.points
    n = length(ps) - !isclosed(c)

    return [Segment(ps[i], ps[i + 1]) for i in 1:n]
end

function segments(ps::AbstractVector{<:Point})
    # some abuse of notation here using isclosed for points
    n = length(ps) - !isclosed(ps)

    return [Segment(ps[i], ps[i + 1]) for i in 1:n]
end

