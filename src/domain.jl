# TODO: add AubstractGeometry as supertype of all shapes in geometry.jl
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

# %%=======================================================================================
# operations on composite domains
# =========================================================================================
# TODO: clipping
function union(domains::CompositeDomain{T}...) where {T}
    combined_entities = vcat([domain.entities for domain in domains]...)
    return CompositeDomain{T}(combined_entities...)
end


function intersection(domain1::CompositeDomain{T}, domain2::CompositeDomain{T}) where {T}
    # Implement intersection logic specific to the types of entities in the domains
    # For simplicity, assume they intersect if they share any points (more complex logic can be added)
    intersected_entities = [entity for entity in domain1.entities if entity in domain2.entities]
    return CompositeDomain{T}(intersected_entities...)
end






# [path1, path2, path3] = [CircularArc(Point(0, 0), Point(1, 0), Point(0.5, 0.5)),
#                         CircularArc(Point(1, 0), Point(1, 1), Point(0.5, 0.5)),
#                         CircularArc(Point(1, 1), Point(0, 1), Point(0.5, 0.5))]



# ]
=#