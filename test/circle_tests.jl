using Test
using DotGeometry

@testset "Circle Tests" begin
    # Test Circle creation with 3 points
    p1 = Point(0.0, 1.0)
    p2 = Point(1.0, 0.0)
    p3 = Point(0.0, -1.0)
    center, r = Circle(p1, p2, p3)
    @test center == Point(0.0, 0.0)
    @test r == 1.0

    # Test Circle evaluation at t=0 (should be the point on the positive x-axis)
    c = Circle(center, 1.0)
    @test c(0.0) == Point(1.0, 0.0)

    # Test Circle evaluation at t=0.25 (should be the point on the positive y-axis)
    @test isapprox(c(0.25), Point(0.0, 1.0), atol=1e-10)

    # Test Circle evaluation at t=0.5 (should be the point on the negative x-axis)
    @test isapprox(c(0.5), Point(-1.0, 0.0), atol=1e-10)

    # Test Circle evaluation at t=0.75 (should be the point on the negative y-axis)
    @test isapprox(c(0.75), Point(0.0, -1.0), atol=1e-10)

    # Test Circle evaluation at t=1.0 (should return to the original point)
    @test isapprox(c(1.0), Point(1.0, 0.0), atol=1e-10)

    # Test that creating a circle from collinear points throws an error
    p_col1 = Point(0.0, 0.0)
    p_col2 = Point(1.0, 1.0)
    p_col3 = Point(2.0, 2.0)
    @test_throws ErrorException Circle(p_col1, p_col2, p_col3)
end

@testset "CircularArc Tests" begin
    # Test CircularArc creation with two points and the center
    p1 = Point(1.0, 0.0)
    p2 = Point(0.0, 1.0)
    center = Point(0.0, 0.0)
    arc = CircularArc(p1, p2, center)

    @test arc.center == center
    @test arc.radius == 1.0
    @test arc.θ1 == 0.0
    @test arc.θ2 == π/2
    @test arc.Δθ == π/2

    # Test CircularArc evaluation at t=0 (should return p1)
    @test arc(0.0) == p1

    # Test CircularArc evaluation at t=1 (should return p2)
    @test isapprox(arc(1.0), p2)

    # Test CircularArc evaluation at t=0.5 (midpoint of the arc)
    midpoint = arc(0.5)
    expected_mid = Point(sqrt(2)/2, sqrt(2)/2)  # Midpoint of the arc
    @test isapprox(midpoint, expected_mid)

    # Test CircularArc creation with swapped points and positive=false
    # arc_negative = CircularArc(p2, p1, center, positive=false)
    # @test arc_negative.points[1] == p2
    # @test arc_negative.points[2] == p1

    # Test CircularArc creation with two points and a radius
    p3 = Point(1.0, 0.0)
    p4 = Point(0.0, 1.0)
    r = 1.0
    arc2 = CircularArc(p3, p4, r)

    @test isapprox(arc2.center, center, atol=1e-10)
    @test isapprox(arc2.radius, r)
    @test arc2.points == [p3, p4]

    # Test get_circle_center function
    center_calc = get_circle_center(p3, p4, r)
    @test isapprox(center_calc, Point(0.0, 0.0), atol=1e-10)

    # Test that no circle can be formed if distance between points > 2 * radius
    p5 = Point(0.0, 0.0)
    p6 = Point(3.0, 0.0)
    @test_throws ErrorException get_circle_center(p5, p6, 1.0)
end
