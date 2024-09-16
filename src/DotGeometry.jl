module DotGeometry

using LinearAlgebra
using StaticArrays
using Plots: @recipe

abstract type AbstractGeometry{T} end
abstract type AbstractCurve{T} <: AbstractGeometry{T} end
abstract type AbstractChain{T} <: AbstractGeometry{T} end

include("point.jl")
include("segment.jl")
include("chains.jl")
include("bezier.jl")
include("predicates.jl")
include("circle.jl")
include("domain.jl")
include("discretize.jl")
include("visualization.jl")

export Point, getx, gety, origin
export Segment, segments
export LineString, AbstractChain, AbstractCurve, Polygon
export BezierCurve, BezierAlgorithm, DeCasteljau
export isclosed, get_typename
export Circle, CircularArc, get_circle_center
export CompositeDomain, AbstractDomain
export discretize_boundary, discretize_domain

end
