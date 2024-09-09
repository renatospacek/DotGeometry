@recipe function f(ps::AbstractVector{<:Point})
    return getx(ps), gety(ps)
end

@recipe function f(c::AbstractCurve)
    isa(c, Segment) && return getx(c.points), gety(c.points)

    ps = c.(0:0.01:1)
    return getx(ps), gety(ps)
end

function get_typename(c)
    return Base.typename(typeof(c)).wrapper
end

