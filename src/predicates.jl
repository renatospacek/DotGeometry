# TODO: isclosed for domains

# for chains
isclosed(c::AbstractChain) = c.points[1] == c.points[end]
# for points; abuse of notation (to change)
isclosed(points::AbstractVector{<:Point}) = points[1] == points[end]

# function get_endpoints(c::AbstractCurve)

# end


# TODO
# isin(point, domain)

# TODO

