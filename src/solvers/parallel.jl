"""
    parallel_solver(streetGraph::StreetGraph, lookahead=5)

A greedy algorithm that solves the problem by sending the cars all at once

# Parameters
- `streetGraph`: The graph format of the City
- `lookahead`: The number of steps to lookahead
"""
function parallel_solver(streetGraph::StreetGraph, lookahead=5)
    (; graph, N, start, totalTime) = streetGraph

    solution = [Vector{Int64}([start]) for _ in 1:N]
    times = zeros(N)

    while any(time -> time < totalTime, times)
        for i in 1:N
            if times[i] >= totalTime
                continue
            end

            route = solution[i]
            current = last(route)

            _, bestNode = bestStepLookahead(streetGraph, current, lookahead)
            bestEdgeVal = get_edgeval(graph, current, bestNode)
            (; duration, rate, nvisited) = bestEdgeVal
            times[i] += duration

            if times[i] <= totalTime
                push!(route, bestNode)
                incrementNVisited!(streetGraph, current, bestNode)
            else
                break
            end
        end
    end
    return Solution(solution)
end
