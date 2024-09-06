# TODO: when plotting bezier, don't show control points
# @recipe function f(ps::Vector{<:Point})
#     # return [x[1] for x in ps], [x[2] for x in ps]
#     return getx(ps), gety(ps)
# end

# # @recipe function f(ls::Vector{<:Point})
# #     # markershape --> :circle
# #     # markersize  --> 2
# #     return [x[1] for x in ps], [x[2] for x in ps]
# # end

# @recipe function f(ls::LineString)

#     return getx(ls.points), gety(ls.points)
# end

# # Recipe for plotting a vector of LineStrings with different colors
# @recipe function f(ls::AbstractVector{<:LineString})
#     # Set the series type to be a line for each LineString
#     seriestype := :path

#     # Iterate over each LineString in the vector
#     for line in ls
#         # Extract the x and y coordinates from each LineString
#         x = get_x(line.points)
#         y = get_y(line.points)

#         # Plot each LineString as a separate series
#         @series begin
#             x, y
#         end
#     end
# end

@recipe function f(ps::AbstractVector{<:Point})
    # return [x[1] for x in ps], [x[2] for x in ps]
    return getx(ps), gety(ps)
end

@recipe function f(c::AbstractCurve)
    isa(c, Segment) && return getx(c.points), gety(c.points)

    ps = c.(0:0.01:1)
    return getx(ps), gety(ps)
end



