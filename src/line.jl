
"""
    Line{T}(p1::Point{T}, p2::Point{T})

A line in 2D space passing through points `p1` and `p2`.
"""
struct Line{T} #<: AbstractShape{T}
    p1::Point{T}
    p2::Point{T}
end

# TODO: method for mixed vectors and tuples
Line(p1::Point{T}, p2::Point{T}) where {T} = Line{T}(p1, p2)
Line(p1::Point{T}, p2::Point{S}) where {T, S} = Line(promote_points(p1, p2)...)
Line(p1::Tuple{T,T}, p2::Tuple{T,T}) where {T} = Line(Point(p1), Point(p2))
Line(v1::AbstractVector{T}, v2::AbstractVector{T}) where {T} = Line(Point(v1), Point(v2))

Line(p1::NTuple{2,T}, p2::NTuple{2,S}) where {T, S} = Line(promote_points(Point(p1), Point(p2))...)
Line(v1::AbstractVector{T}, v2::AbstractVector{S}) where {T, S} = Line(promote_points(Point(v1), Point(v2))...)

Base.:(==)(l₁::Line, l₂::Line) = l₁.p1 in l₂ && l₁.p1 in l₂

(l::Line)(t) = t*(l.p2 - l.p1) + l.p1