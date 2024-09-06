"""
    BezierCurve{T}(p1, p2, ..., pn)

Bézier curve defined by control points `points`.
"""
struct BezierCurve{T} <: AbstractCurve{T}
    points::Vector{Point{T}}
end

# Convenience constructors
BezierCurve(points::AbstractVector{<:Point}) = BezierCurve(points)
BezierCurve(points::Point...) = BezierCurve(collect(points))

abstract type BezierAlgorithm end

struct DeCasteljau <: BezierAlgorithm end

"""
    (c::BezierCurve{T})(t, algorithm::BezierAlgorithm = DeCasteljau()) where {T}

Evaluate the Bzier curve `c` at parameter `t` with a given `algorithm` (defaults to de Casteljau)

# Examples
```jldoctest
julia> c = BezierCurve(Point(0, 0), Point(1, 1), Point(2, 0))
"""
(c::BezierCurve)(t, algorithm::BezierAlgorithm = DeCasteljau()) = evaluate(algorithm, c.points, t)
# (c::BezierCurve{T})(t::Vector{T}) = de_casteljau_n.(Ref(c.points), t)

"Methods for evaluating Bézier curves for different algorithms"
function evaluate(::DeCasteljau, points::AbstractVector{<:Point}, t::Float64)
    (t < 0 || t > 1) && throw(DomainError(t, "t must be defined in [0, 1]."))
    length(points) == 1 && return points[1]

    ls = segments(points)
    new_points = [l(t) for l in ls]

    return evaluate(DeCasteljau(), new_points, t)
end

# function Base.show(io::IO, b::BezierCurve)
#     ioctx = IOContext(io, :compact => true)
#     print(io, "BezierCurve with control points:")
#     join(ioctx, b.points, ", ")
#     print(io, "])")
# end

# Base.show(io::IO, ::MIME"text/plain", b::BezierCurve) = print(io, d.n, " day")

# function Base.show(io::IO, ::MIME"text/plain", b::BezierCurve)
#     summary(io, b)
#     println(io)
#     print(io, "└─ controls: [")
#     join(io, b.controls, ", ")
#     print(io, "]")
#   end