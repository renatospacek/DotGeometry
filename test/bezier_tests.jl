using Test
using DotGeometry

# Define shared points outside @testset so they are accessible in multiple test sets
p1 = Point(0.0, 0.0)
p2 = Point(1.0, 1.0)
p3 = Point(2.0, 0.0)

@testset "BezierCurve Tests" begin
    # Test BezierCurve creation using vector of Points
    curve1 = BezierCurve([p1, p2, p3])
    @test length(curve1.points) == 3
    @test curve1.points == [p1, p2, p3]

    # Test BezierCurve creation using Point arguments
    curve2 = BezierCurve(p1, p2, p3)
    @test length(curve2.points) == 3
    @test curve2.points == [p1, p2, p3]

    # Test evaluation at t=0 (should return the first point)
    p_start = curve1(0.0)
    @test p_start == p1

    # Test evaluation at t=1 (should return the last point)
    p_end = curve1(1.0)
    @test p_end == p3

    # Test evaluation at t=0.5 (midpoint of quadratic Bezier curve)
    p_mid = curve1(0.5)
    expected_mid = Point(1.0, 0.5)  # Expected midpoint for this quadratic Bezier curve
    @test p_mid == expected_mid

    # Test for DomainError if t is out of bounds
    @test_throws DomainError curve1(-0.1)
    @test_throws DomainError curve1(1.1)
end

@testset "BezierCurve Algorithm Tests" begin
    # Test de Casteljau algorithm for linear Bezier curve
    p4 = Point(0.0, 0.0)
    p5 = Point(2.0, 2.0)
    curve3 = BezierCurve(p4, p5)

    # Evaluate at t=0.5 (should be the midpoint of a linear curve)
    p_mid_linear = curve3(0.5)
    expected_mid_linear = Point(1.0, 1.0)
    @test p_mid_linear == expected_mid_linear

    # Test de Casteljau algorithm for cubic Bezier curve
    p6 = Point(3.0, 0.0)
    curve4 = BezierCurve(p1, p2, p3, p6)

    # Evaluate at t=0.0 (should be the first point)
    p_start_cubic = curve4(0.0)
    @test p_start_cubic == p1

    # Evaluate at t=1.0 (should be the last point)
    p_end_cubic = curve4(1.0)
    @test p_end_cubic == p6
end
