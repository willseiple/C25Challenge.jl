"""
    feasible_check(Solution)

Check if `solution` satisfies the constraints of the problme statement
The following criteria are considered:
- the number of itineraries has to match the number of cars that traverse the `city``
- the first junction of each itinerary has to be the starting junction of `city`
- for each consecutive pair of junctions on an itinerary, a street connecting these junctions has to exist in `city` (if the street is one directional, it has to be traversed in the correct direction)
- the duration of each itinerary has to be lower or equal to the total duration of `city`
"""
function feasible_check(solution::Solution; verbose=false)
    streetGraph = StreetGraph(read_city())
    (; graph, N, start, totalTime) = streetGraph

    if length(solution.itineraries) != N
        verbose && @warn "Incoherent number of cars"
        return false
    end
    for (idx, itinerary) in enumerate(solution.itineraries)
        if first(itinerary) != start
            verbose && @warn "Itinerary $idx has invalid starting junction"
            return false
        end
        duration = 0
        for node in 1:(length(itinerary) - 1)
            # check edges for graph
            i, j = itinerary[node], itinerary[node + 1]
            duration += get_edgeval(graph, i, j).duration
            if !has_edge(graph, i, j)
                verbose && @warn "Street $i -> $j does not exist"
                return false
            end
        end
        if duration > totalTime
            verbose && @warn "Itinerary $idx has duration $duration > $(totalTime)"
            return false
        end
    end
    return true
end

"""
    compute_distance(solution::Solution)

Computes the total distance of all itineraries in `solution` based on the StreetGraph
Streets visited several times are only counted once.
"""
function compute_distance(solution::Solution)
    streetGraph = StreetGraph(read_city())
    (; graph, N, start, totalTime) = streetGraph

    total_distance = 0

    for itin in solution.itineraries
        for node in 1:(length(itin) - 1)
            i, j = itin[node], itin[node + 1]
            if has_edge(graph, i, j)
                (; duration, rate, nvisited) = get_edgeval(graph, i, j)
                total_distance += nvisited == 0 ? duration * rate : 0
                incrementNVisited!(streetGraph, i, j)
            else
                @warn "Invalid edge $i --> $j"
                return false
            end
        end
    end
    return total_distance
end
