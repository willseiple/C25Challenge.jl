"""
    series_solver(streetGraph::StreetGraph, lookahead=5)

A greedy algorithm that solves the problem by sending the cars one after another.

# Parameters
- `streetGraph`: The graph format of the City
- `lookahead`: The number of steps to lookahead
"""
function series_solver(streetGraph::StreetGraph, lookahead=5)
    (; graph, N, start, totalTime) = streetGraph

    solution = [Vector{Int64}([start]) for _ in 1:N]

    for car in 1:N
        time = 0
        route = solution[car]
        while true
            current = last(route)
            _, bestNode = bestStepLookahead(streetGraph, current, lookahead)
            (; duration, rate, nvisited) = get_edgeval(graph, current, bestNode)
            time += duration

            if time <= totalTime
                push!(route, bestNode)
                incrementNVisited!(streetGraph, current, bestNode)
                current = bestNode
            else
                break
            end
        end
    end
    return Solution(solution)
end
