
"""
    bestStepLookahead(graph::StreetGraph, currentNode::Integer, depth=5)

A lookahead function that calulates a heuristic and returns the corresponding next best node.

# Parameters
- `graph`: The graph format of the City
- `currentNode`: The current junction or node we are looking ahead after
- `depth`: The depth of the lookahead search
"""
function bestStepLookahead(graph::StreetGraph, currentNode::Integer, depth=5)
    if depth == 0
        return 0, nothing
    end

    (edgeVals, outNeighbors, _) = outInformation(graph, currentNode)
    bestScore = typemin(Int64)
    bestStep = 0

    for (i, neighbor) in enumerate(outNeighbors)
        # handles bidirectional case
        incrementNVisited!(graph, currentNode, neighbor)
        currentScore, _ = bestStepLookahead(graph, neighbor, depth - 1)
        # reset graph to original state
        decrementNVisited!(graph, currentNode, neighbor)
        currentScore += calcValue(edgeVals[i])

        if currentScore > bestScore
            bestScore = currentScore
            bestStep = neighbor
        end
    end

    return bestScore, bestStep
end

"""
    outInformation(g::StreetGraph, node::Integer)

Returns the information about the node. Specifically, the outedgevals, outneighbors, and max rate index
    outvals, outneighbors, idx_max = outInformation(g::StreetGraph, node::Integer)


# Parameters
- `streetGraph`: The graph format of the City
- `node`: The node on the graph format to get information about
"""
function outInformation(g::StreetGraph, node::Integer)
    outvals = outedgevals(g, node, 1)
    idx_max = argmax(calcValue.(outvals))
    return outvals, outneighbors(g.graph, node), idx_max
end

"""
    calcValue(weight::EdgeWeight)

Calculates a heuristic given an edge.

# Parameters
- `weight`: The EdgeWeight that you calculate the heuristic on
"""
function calcValue(weight::EdgeWeight)
    (; duration, rate, nvisited) = weight
    # value = nvisited == 0 ? rate : (0.3)^nvisited * rate
    value = nvisited == 0 ? rate * duration : -nvisited * duration
    return value
end

"""

NEW UTILS !!! NEED TO DOCUMENT THESE

"""
function updateNVisited!(
    streetGraph::StreetGraph, from::Integer, to::Integer, newVal::Integer
)
    graph = streetGraph.graph
    (; duration, rate, nvisited) = get_edgeval(graph, from, to)
    weight = EdgeWeight(duration, rate, newVal)
    add_edge!(graph, from, to, (weight,))
    if has_edge(graph, to, from)
        add_edge!(graph, to, from, (weight,))
    end
end

function incrementNVisited!(streetGraph::StreetGraph, from::Integer, to::Integer)
    nvisited = get_edgeval(streetGraph.graph, from, to).nvisited
    return updateNVisited!(streetGraph, from, to, nvisited + 1)
end

function decrementNVisited!(streetGraph::StreetGraph, from::Integer, to::Integer)
    nvisited = get_edgeval(streetGraph.graph, from, to).nvisited
    return updateNVisited!(streetGraph, from, to, nvisited - 1)
end
