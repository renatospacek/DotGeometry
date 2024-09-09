using Test
using DotGeometry

@testset "CompositeDomain Tests" begin
    # Test CompositeDomain creation with simple entities (LineString and CircularArc)

    # Create a few simple shapes (LineString and CircularArc)
    p1 = Point(0.0, 0.0)
    p2 = Point(1.0, 0.0)
    p3 = Point(1.0, 1.0)
    p4 = Point(0.0, 1.0)

    line1 = LineString(p1, p2, p3)
    arc1 = CircularArc(p3, p4, Point(0.5, 0.5))

    # Create a CompositeDomain
    domain1 = CompositeDomain(line1, arc1)

    # Ensure the domain holds the correct entities
    @test length(domain1.entities) == 2
    @test domain1.entities == [line1, arc1]

    # Test CompositeDomain creation with multiple curves and segments
    line2 = LineString(p4, p1)
    arc2 = CircularArc(p2, p3, Point(0.5, 0.0))

    domain2 = CompositeDomain(line1, arc1, line2, arc2)

    @test length(domain2.entities) == 4
    @test domain2.entities == [line1, arc1, line2, arc2]

    # Test that CompositeDomain works with different curve types
    domain3 = CompositeDomain([line1, arc1])
    @test length(domain3.entities) == 2

    # Test type promotion
    float_domain = CompositeDomain(LineString(Point(0.0, 0.0), Point(1.0, 0.0)), CircularArc(Point(1.0, 0.0), Point(0.0, 1.0), Point(0.5, 0.5)))
    @test typeof(float_domain.entities[1]) == LineString{Float64}

    # Test union of two CompositeDomains
    combined_domain = union(domain1, domain2)
    @test length(combined_domain.entities) == 6  # 2 entities in domain1 + 4 entities in domain2

    # Test intersection of two CompositeDomains
    intersection_domain = intersection(domain1, domain2)
    @test length(intersection_domain.entities) == 1  # Should only share one entity (line1)
    @test intersection_domain.entities == [line1]
end