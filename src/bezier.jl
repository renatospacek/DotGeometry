"""
    BezierCurve([p₁, p₂, ..., pₙ])
    BezierCurve(p₁, p₂, ..., pₙ)

Bézier curve defined by control points `p₁, ..., pₙ`.
"""
struct BezierCurve{T} <: AbstractCurve{T}
    points::Vector{Point{T}}
end

# Convenience constructors
BezierCurve(points::AbstractVector{<:Point}) = BezierCurve(points)
BezierCurve(points::Point...) = BezierCurve(collect(points))

"Algorithms for evaluating Bézier curves"
abstract type BezierAlgorithm end
struct DeCasteljau <: BezierAlgorithm end

"""
    (c::BezierCurve(t, algorithm))
    (c::BezierCurve(t, algorithm=DeCasteljau())

Evaluate Bézier curve `c` at parameter `t` in [0,1] with `algorithm` (defaults to de Casteljau)
"""
(c::BezierCurve)(t, algorithm::BezierAlgorithm = DeCasteljau()) = evaluate(algorithm, c.points, t)

# Methods for evaluating Bézier curves for different algorithms
function evaluate(::DeCasteljau, points::AbstractVector{<:Point}, t::Float64)
    (t < 0 || t > 1) && throw(DomainError(t, "t must be defined in [0, 1]."))
    length(points) == 1 && return points[1]

    ls = segments(points)
    new_points = [l(t) for l in ls]

    return evaluate(DeCasteljau(), new_points, t)
end