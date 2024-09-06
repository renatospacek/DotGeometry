# TODO: maybe add methods for tuple of tuples and tuple of vectors and vector of vectors for LineString?
# TODO: conversion type if points not all the same type into linestring
"""
    struct LineString{T}

A collection of points connected by line segments
"""
struct LineString{T} <: AbstractChain{T}
    points::Vector{Point{T}}
    closed::Bool

    function LineString(points::Vector{Point{T}}, closed::Bool) where {T}
        @assert points[1] != points[end] "First and last points are the same. For a closed chain, set `closed = true`"

        closed && push!(points, points[1])
        new{T}(points, closed)
    end
end

LineString(points::AbstractVector{<:Point}; closed::Bool = false) = LineString(points, closed)
LineString(points::Tuple...; closed::Bool=false) = LineString([Point(p) for p in points], closed)
LineString(points::Point...; closed::Bool=false) = LineString(collect(points), closed)
LineString(points::AbstractVector{<:Tuple}; closed::Bool=false) = LineString(Point.(points), closed)

# Convenience constructor using keyword arg for closed
# LineString(points::Vector{Point{T}}; closed::Bool = false) where {T} = LineString(points, closed)
# # Constructor from vector of tuples
# LineString(tuples::Vector{Tuple{T,T}}; closed::Bool=false) where {T} = LineString(Point{T}[tuples...], closed)
# # Constructor by passing points directly
# LineString(points::Point{T}...; closed::Bool=false) where {T} = LineString(Point{T}[points...], closed)
# # Constructor by passing tuples directly
# LineString(tuples::Tuple{T,T}...; closed::Bool=false) where {T} = LineString(Point{T}[tuples...], closed)


LineString(points::Tuple...; closed::Bool=false) = LineString([Point(p) for p in points], closed)
LineString(points::Point; closed::Bool=false) = LineString(collect(points), closed)
LineString(points::AbstractVector{<:Tuple}; closed::Bool=false) = LineString(Point.(points), closed)

# function (c::LineString)(t)
#     ls = segments(c)
#     return [l(t) for l in ls]
# end

"""
    Polygon(N; center::Point{T} = origin, r::T = one(T))

Constructs a r regular polygon with N vertices centered at `center` and radius `r`. If not specified, `center` defaults to the origin and `r` defaults to 1.
"""
function Polygon(N::Int; center::Point{T} = origin, r::T = one(T)) where {T}
    θ = range(0.0, 2π, N)
    x = center[1] .+ r*cos.(θ)
    y = center[2] .+ r*sin.(θ)
    points = [Point(x[i], y[i]) for i in 1:N]

    return LineString(points, true)
end
