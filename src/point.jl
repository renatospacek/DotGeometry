# abstract type AbstractPoint{N,T} <: FieldVector{N,T} end

# const Point{T} = FieldVector{2,T}
# const Segment{T} = SVectorx{2,Point{T}}
# const Polygon{T} = Vector{<:Point{T}}
"""
    Point{T}(x, y)

A point in 2D space with coordinates `x` and `y`.
"""
struct Point{T<:AbstractFloat} <: FieldVector{2,T}
    x::T
    y::T
end

# Convenience constructors; we need everything as floats, but not allowing Point(1,2) would be annoying
Point(x::T,y::T) where {T<:Integer} = Point{Float64}(x,y)
Point(p::NTuple{2,<:Integer}) = Point{Float64}(p...)
Point(p::AbstractVector{<:Integer}) = Point{Float64}(p...)

Base.:(*)(p1::Point{T}, p2::Point{T}) where {T} = Point{T}(p1.*p2)
StaticArrays.similar_type(::Type{<:Point}, ::Type{T}, s::Size{(2,)}) where {T} = Point{T}

# function promote_points(p1::Point{T1}, p2::Point{T2}) where {T1, T2}
#     x1, x2 = promote(p1.x, p2.x)
#     y1, y2 = promote(p1.y, p2.y)
#     return Point(x1, y1), Point(x2, y2)
# end

# function getx(points::AbstractVector{<:Point},
#               idx::AbstractVector{Int} = 1:length(points))
#      return [p[1] for p in points[idx]]
# end
# function gety(points::AbstractVector{<:Point},
#               idx::AbstractVector{Int} = 1:length(points))
#      return [p[2] for p in points[idx]]
# end
# getx(points::AbstractVector{<:Point}) = getx(points, 1:length(points))
# gety(points::AbstractVector{<:Point}) = gety(points, 1:length(points))
# getx(points::AbstractVector{<:Point}, idx::AbstractVector{Int}) = [p[1] for p in points[idx]]
# gety(points::AbstractVector{<:Point}, idx::AbstractVector{Int}) = [p[2] for p in points[idx]]
getx(points::AbstractVector{<:Point}) = [p[1] for p in points]
gety(points::AbstractVector{<:Point}) = [p[2] for p in points]

const origin = Point(0.0, 0.0)