"""
    Point(x, y)

A point in 2D space with coordinates `x` and `y`.
"""
struct Point{T<:AbstractFloat} <: FieldVector{2,T}
    x::T
    y::T
end

# Convenience constructors; we need everything as floats, but not allowing Point(1, 2) would be annoying
Point(x::T, y::T) where {T<:Integer} = Point{Float64}(x,y)
Point(p::NTuple{2,<:Integer}) = Point{Float64}(p...)
Point(p::AbstractVector{<:Integer}) = Point{Float64}(p...)

Base.:(*)(p1::Point{T}, p2::Point{T}) where {T} = Point{T}(p1.*p2)
StaticArrays.similar_type(::Type{<:Point}, ::Type{T}, s::Size{(2,)}) where {T} = Point{T}

"""
    getx([p₁, p₂, ..., pₙ])
    gety([p₁, p₂, ..., pₙ])

Get the x and y-coordinates of a vector of points.
"""
getx(points::AbstractVector{<:Point}) = [p[1] for p in points]
gety(points::AbstractVector{<:Point}) = [p[2] for p in points]

"Alias for the origin for convenience"
const origin = Point(0.0, 0.0)