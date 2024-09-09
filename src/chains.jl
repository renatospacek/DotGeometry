# TODO: maybe add methods for tuple of tuples and tuple of vectors and vector of vectors for LineString?
"""
    LineString([p₁, p₂, ..., pₙ], isclosed)
    LineString([p₁, p₂, ..., pₙ])
    LineString(p₁, p₂, ..., pₙ)
    LineString((x₁, y₁), (x₂, y₂), ..., (xₙ, yₙ))

An (open or closed) polygonal chain represented by its vertices `p₁, p₂, ..., pₙ`.

Defaults to open if `isclosed` is not specified.

NOTE: The first and last points must be different.
Periodicity is accounted for by setting `isclosed = true`.
"""
struct LineString{T} <: AbstractChain{T}
    points::Vector{Point{T}}
    isclosed::Bool

    function LineString(points::Vector{Point{T}}, isclosed::Bool) where {T}
        @assert points[1] != points[end] "First and last points are the same. For a closed chain, set `isclosed = true`"

        isclosed && push!(points, points[1])
        new{T}(points, isclosed)
    end
end

# Convenience constructors
LineString(points::AbstractVector{<:Point}; isclosed::Bool = false) = LineString(points, isclosed)
LineString(points::Tuple...; isclosed::Bool=false) = LineString([Point(p) for p in points], isclosed)
LineString(points::Point...; isclosed::Bool=false) = LineString(collect(points), isclosed)
LineString(points::AbstractVector{<:Tuple}; isclosed::Bool=false) = LineString(Point.(points), isclosed)

"""
    Polygon(N; center=origin, r::1.0)
    Polygon(N)

Construct a regular polygon with `N` vertices centered at `center` with radius `r`.

If not specified, `center` is set to the origin and `r` to 1.0.
"""
function Polygon(N::Int; center::Point = origin, r::Float64 = 1.0)
    θ = range(0, 2π, N)
    x = center[1] .+ r.*cos.(θ)
    y = center[2] .+ r.*sin.(θ)
    points = [Point(x[i], y[i]) for i in 1:N]

    return LineString(points, true)
end