abstract type AbstractDomain{T} end

"""
    CompositeDomain{T}(entities...)

Domain composed of multiple connected entities `entities` (e.g. Bezier curves, arcs, segments etc).
"""
struct CompositeDomain{T} <: AbstractDomain{T}
    entities::Vector{<:AbstractCurve{T}}
end

"Constructor for CompositeDomain"
CompositeDomain(entities::AbstractCurve...) = CompositeDomain(collect(entities))

function CompositeDomain(shapes::AbstractVector{<:AbstractCurve})
    # make this accept abstractgeometries and use segments() to flatten chains into segments in the entity list here
    T = promote_type(map(x -> eltype(x), shapes)...)
    return CompositeDomain{T}(map(x -> convert(AbstractShape{T}, x), shapes))
end


#=
# flattens chains into segments
function CompositeDomain(shapes::AbstractVector{<:AbstractGeometry})
    cs = AbstractCurve[]

    for shape in shapes
        append!(cs, segments(shape))
    end

    T = promote_type(map(x -> eltype(x), cs)...)
    return CompositeDomain{T}(map(x -> convert(AbstractCurve{T}, x), cs))
end

CompositeDomain(entities::AbstractGeometry...) = CompositeDomain(collect(entities))

# flattens chains into segments
function CompositeDomain(shapes::AbstractVector{<:AbstractGeometry})
    cs = AbstractCurve[]

    for shape in shapes
        append!(cs, segments(shape))
    end

    return CompositeDomain{Float64}(shapes)
end
=#