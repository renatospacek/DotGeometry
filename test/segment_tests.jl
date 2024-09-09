using Test
using DotGeometry
using StaticArrays

@testset "Segment Tests" begin
    # Test segment creation using two Points
    p1 = Point(0.0, 0.0)
    p2 = Point(3.0, 4.0)
    seg1 = Segment(p1, p2)
    @test seg1.points[1] == p1
    @test seg1.points[2] == p2

    # Test segment creation using tuples
    seg2 = Segment((0.0, 0.0), (3.0, 4.0))
    @test seg2.points[1] == Point(0.0, 0.0)
    @test seg2.points[2] == Point(3.0, 4.0)

    # Test segment creation using a vector of Points
    seg3 = Segment([p1, p2])
    @test seg3.points == SVector(p1, p2)

    # Test segment creation using a vector of tuples
    seg4 = Segment([(0.0, 0.0), (3.0, 4.0)])
    @test seg4.points == SVector{2,Point}(Point(0.0, 0.0), Point(3.0, 4.0))

    # Test evaluation of the segment at t=0 (should return the first point)
    @test seg1(0.0) == p1

    # Test evaluation of the segment at t=1 (should return the second point)
    @test seg1(1.0) == p2

    # Test evaluation of the segment at t=0.5 (midpoint of the segment)
    mid_point = seg1(0.5)
    expected_mid = Point(1.5, 2.0)
    @test mid_point == expected_mid

    # Test for DomainError if t is out of bounds
    @test_throws DomainError seg1(-0.1)
    @test_throws DomainError seg1(1.1)

    # Test segment equality
    seg5 = Segment(p1, p2)
    seg6 = Segment(Point(0.0, 0.0), Point(3.0, 4.0))
    @test seg5 == seg6

    # Test segment inequality (different points)
    seg7 = Segment(Point(0.0, 0.0), Point(1.0, 1.0))
    @test seg5 != seg7

    # Test splitting a polygonal chain into segments
    chain_points = [Point(0.0, 0.0), Point(1.0, 1.0), Point(2.0, 2.0)]
    segs = segments(chain_points)
    @test length(segs) == 2
    @test segs[1] == Segment(Point(0.0, 0.0), Point(1.0, 1.0))
    @test segs[2] == Segment(Point(1.0, 1.0), Point(2.0, 2.0))
end
