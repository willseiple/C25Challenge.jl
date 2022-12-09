"""
    Stores the information of a city in a Graph.
"""
function GraphFormat(city::City)
    graph = SimpleWeightedDiGraph(length(city.junctions))
    for s in city.streets
        add_edge!(graph, s.endpointA, s.endpointB, s.duration)
        if s.bidirectional
            add_edge!(graph, s.endpointB, s.endpointA, s.duration)
        end
    end
    return graph
end
"""
    simple random walk on a graph that is little code but does basically the same as
    `HashCode2014.random_walk`
"""
function graph_random_walk(city::City, walk_iterations::Int64)
    (; nb_cars, starting_junction) = city
    graph = GraphFormat(city)
    return Solution([
        randomwalk(graph, starting_junction, walk_iterations) for _ in 1:nb_cars
    ])
end
