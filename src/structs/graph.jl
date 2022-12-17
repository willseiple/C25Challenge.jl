"""
    StreetGraph

Master graph representing the street system of a City, wrapper for ValOutDiGraph and stores other properties of the problem.

# Fields
- `graph::SimpleValueGraphs.ValOutDiGraph`: Graph Representation of the City 
- `N::Integer`: number of cars
- `start::Integer`: The index of the initial junction
- `totalTime::Integer`: time limit of the problem
"""
struct StreetGraph
    graph::SimpleValueGraphs.ValOutDiGraph{
        Int32,
        Tuple{Int64},
        Tuple{EdgeWeight},
        Tuple{},
        Tuple{Vector{Int64}},
        Tuple{Vector{Vector{EdgeWeight}}},
    }
    N::Integer
    start::Integer
    totalTime::Integer

    StreetGraph(city::City) = initStreetGraph(city)
    StreetGraph(g::ValOutDiGraph, n::Integer, st::Integer, tT::Integer) = new(g, n, st, tT)
end

"""
    Used to construct a StreetGraph, returns StreetGraph object
"""
function initStreetGraph(city::City)
    (; total_duration, starting_junction, nb_cars, streets, junctions) = city

    graph = ValOutDiGraph(
        length(junctions);
        vertexval_types=(Int64,),
        vertexval_init=v -> (v,),
        edgeval_types=(EdgeWeight,),
    )

    for s in streets
        edgeWeight = EdgeWeight(s)
        add_edge!(graph, s.endpointA, s.endpointB, (edgeWeight,))
        if s.bidirectional
            add_edge!(graph, s.endpointB, s.endpointA, (edgeWeight,))
        end
    end

    return StreetGraph(graph, nb_cars, starting_junction, total_duration)
end

function outedgevals(g::StreetGraph, node::Integer, key::Integer)
    return [get_edgeval(g.graph, node, v, key) for v in outneighbors(g.graph, node)]
end

"""
    Problem()

Return a [`StreetGraph`](@ref)
"""
function Problem()
    return StreetGraph(read_city())
end
