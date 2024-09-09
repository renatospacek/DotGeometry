using Test
using DotGeometry

@testset "LineString Tests" begin
    # Test LineString creation with vector of Points (open chain)
    p1 = Point(0.0, 0.0)
    p2 = Point(1.0, 0.0)
    p3 = Point(1.0, 1.0)
    ls1 = LineString([p1, p2, p3], false)
    @test ls1.isclosed == false
    @test length(ls1.points) == 3
    @test ls1.points == [p1, p2, p3]

    # Test LineString creation with vector of Points (closed chain)
    ls2 = LineString([p1, p2, p3], true)
    @test ls2.isclosed == true
    @test length(ls2.points) == 4  # Closed chain should have an extra point (p1 repeated)
    @test ls2.points == [p1, p2, p3, p1]

    # Test LineString creation using Point arguments
    ls3 = LineString(p1, p2, p3; isclosed=false)
    @test ls3.isclosed == false
    @test length(ls3.points) == 3
    @test ls3.points == [p1, p2, p3]

    # Test LineString creation with Point arguments (closed)
    ls4 = LineString(p1, p2, p3; isclosed=true)
    @test ls4.isclosed == true
    @test length(ls4.points) == 4
    @test ls4.points == [p1, p2, p3, p1]

    # Test LineString creation using tuples
    ls5 = LineString((0.0, 0.0), (1.0, 0.0), (1.0, 1.0); isclosed=false)
    @test ls5.isclosed == false
    @test length(ls5.points) == 3
    @test ls5.points == [Point(0.0, 0.0), Point(1.0, 0.0), Point(1.0, 1.0)]

    # Test LineString creation with tuples (closed)
    ls6 = LineString((0.0, 0.0), (1.0, 0.0), (1.0, 1.0); isclosed=true)
    @test ls6.isclosed == true
    @test length(ls6.points) == 4
    @test ls6.points == [Point(0.0, 0.0), Point(1.0, 0.0), Point(1.0, 1.0), Point(0.0, 0.0)]

    # Test assertion that first and last points are different for open chain
    @test_throws AssertionError LineString([p1, p2, p1], false)
end

@testset "Polygon Tests" begin
    # Test regular polygon creation with 3 sides (triangle)
    center = Point(0.0, 0.0)
    polygon = Polygon(3; center=center, r=1.0)
    @test polygon.isclosed == true
    @test length(polygon.points) == 4  # 3 vertices + closing point
    @test polygon.points[end] == polygon.points[1]  # First and last point must be the same

    # Test regular polygon creation with 4 sides (square)
    polygon4 = Polygon(4; center=center, r=1.0)
    @test polygon4.isclosed == true
    @test length(polygon4.points) == 5  # 4 vertices + closing point
    @test polygon4.points[end] == polygon4.points[1]

    # Test that polygon with large N (e.g., N=100) still works
    polygon100 = Polygon(100; center=center, r=1.0)
    @test polygon100.isclosed == true
    @test length(polygon100.points) == 101  # 100 vertices + closing point
    @test polygon100.points[end] == polygon100.points[1]

    # Test default center and radius for polygon
    default_polygon = Polygon(5)
    @test default_polygon.isclosed == true
    @test length(default_polygon.points) == 6  # 5 vertices + closing point
    @test default_polygon.points[end] == default_polygon.points[1]  # First and last point must be the same
end
