module DotGeometry

using Plots
using LinearAlgebra
using StaticArrays
using Test
# plotlyjs()

abstract type AbstractGeometry{T} end
abstract type AbstractCurve{T} <: AbstractGeometry{T} end
abstract type AbstractChain{T} <: AbstractGeometry{T} end

# Broadcast.broadcastable(g::BezierCurve) = Ref(g)

include("point.jl")
# include("line.jl")
include("segment.jl")
include("chains.jl")
include("bezier.jl")
include("predicates.jl")
include("circle.jl")
# include("disc_tmp.jl")
include("domain.jl")
include("discretize.jl")
include("visualization.jl")

export Point, getx, gety
export Segment, segments
export LineString, AbstractChain, AbstractCurve, Polygon
export BezierCurve, BezierAlgorithm, DeCasteljau
export isclosed
export Circle, CircularArc
export CompositeDomain, AbstractDomain

end