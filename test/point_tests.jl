using Test
using DotGeometry

# Basic test for point creation
@testset "Point Creation" begin
    # Testing float point creation
    p1 = Point(1.5, 2.5)
    @test p1.x == 1.5
    @test p1.y == 2.5

    # Testing integer point creation and conversion to Float64
    p2 = Point(3, 4)
    @test p2.x == 3.0
    @test p2.y == 4.0

    # Testing creation with tuple
    p3 = Point((5, 6))
    @test p3.x == 5.0
    @test p3.y == 6.0

    # Testing creation with vector
    p4 = Point([7, 8])
    @test p4.x == 7.0
    @test p4.y == 8.0
end

# Testing multiplication (element-wise)
@testset "Point Operations" begin
    p1 = Point(1.0, 2.0)
    p2 = Point(3.0, 4.0)
    p3 = p1 * p2
    @test p3.x == 1.0 * 3.0
    @test p3.y == 2.0 * 4.0
end

# Testing utility functions for getting x and y coordinates
@testset "Utility Functions" begin
    points = [Point(1.0, 2.0), Point(3.0, 4.0), Point(5.0, 6.0)]

    xs = getx(points)
    ys = gety(points)

    @test xs == [1.0, 3.0, 5.0]
    @test ys == [2.0, 4.0, 6.0]
end

# Testing the origin alias
@testset "Origin Alias" begin
    @test origin.x == 0.0
    @test origin.y == 0.0
end