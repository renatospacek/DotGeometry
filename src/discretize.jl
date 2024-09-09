# TODO
# properly sampling points from domain
# integrate: tesselation, triangulation, etc
# regular grid discretization
# domain: bounding box, convex hull
# TODO arc-length parametrization for curves

curve_length(entity) = 1.0 # TODO

function curve_length(b::BezierCurve; n::Int=100)
    ts = range(0, 1, n)
    points = [b(t) for t in ts]

    return sum(norm(points[i] - points[i+1]) for i in 1:(n-1))
end

# %%=======================================================================================
# Discretization
# =========================================================================================
# Just the boundary, for boundary element methods and such
# function discretize_boundary(domain::CompositeDomain, n::Int)# where {T}
#     # discretized_entities = [discretize_entity(entity, n) for entity in domain.entities]
#     discretized_entities = Point[]
#     for entity in domain.entities
#         append!(discretized_entities, discretize_entity(entity, n))
#     end

#     return discretized_entities
# end

# function discretize_entity(entity, n::Int)
#     ts = range(0, 1, n)
#     return entity.(ts)
# end

function discretize_boundary(domain::CompositeDomain, n::Vector{Int})
    @assert length(domain.entities) == length(n) "Length of n must match the number of entities in domain"

    discretized_entities = Point[]
    for (entity, n_value) in zip(domain.entities, n)
        append!(discretized_entities, discretize_entity(entity, n_value))
    end

    return discretized_entities
end

# Discretizes based on a single number of points for all entities
discretize_boundary(domain::CompositeDomain, n::Int) = discretize_boundary(domain, fill(n, length(domain.entities)))

# Discretizes based on step size (Δt)
function discretize_boundary(domain::CompositeDomain, Δt::AbstractFloat)
    npoints = zeros(Int, length(domain.entities))

    for (i, entity) in enumerate(domain.entities)
        entity_length = curve_length(entity)
        npoints[i] = floor(Int, entity_length/Δt)  # Calculate the number of points based on step size
    end

    discretize_boundary(domain, npoints)
end

function discretize_entity(entity, n::Int)
    ts = range(0, 1, n)
    return entity.(ts)
end












# # Elements, for finite volume and stuff
# function discretize_domain(domain::CompositeDomain{T}, n::Int) where {T}
#     # Implement domain discretization logic (e.g., triangulation)
#     # use preexisting packages, i.e. DelaunayTriangulation etc
# end

# function discretize_entity(entity::Polygon, curve::BezierCurve{T}, n::Int) where {T}
#     # make rest of the curves
# end

# Grid discretization, for lattice boltzmann and such
# function discretize_grid(domain::CompositeDomain, nx::Int, ny::Int) where {T}
#     # Implement grid generation for LBM
#     xmin, ymin = minimum([p for p in domain.entities])
#     xmax, ymax = maximum([p for p in domain.entities])

#     dx = (xmax - xmin) / (nx - 1)
#     dy = (ymax - ymin) / (ny - 1)

#     grid = [Point(xmin + i*dx, ymin + j*dy) for j in 0:(ny-1), i in 0:(nx-1)]
#     return GridDiscretization{T}(grid)
# end