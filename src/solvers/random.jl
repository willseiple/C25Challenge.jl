"""
    random_parallel_solver(streetGraph::StreetGraph, lookahead=5, pct_chance=5)

A greedy algorithm that solves the problem in parallel but with random chance of going again

# Parameters
- `streetGraph`: The graph format of the City
- `lookahead`: The number of steps to lookahead
- `pct_chance`: Drives random behavior for a car to go again
"""
function random_parallel_solver(streetGraph::StreetGraph, lookahead=5, pct_chance=5)
    (; graph, N, start, totalTime) = streetGraph

    solution = [Vector{Int64}([start]) for _ in 1:N]
    times = zeros(N)

    while any(time -> time < totalTime, times)
        for i in 1:N
            go_again = true

            while times[i] < totalTime && go_again
                go_again = (pct_chance / 100) < rand(Float64)

                route = solution[i]
                current = last(route)

                _, bestNode = bestStepLookahead(streetGraph, current, lookahead)
                bestEdgeVal = get_edgeval(graph, current, bestNode)
                (; duration, rate, nvisited) = bestEdgeVal
                times[i] += duration

                if times[i] > totalTime
                    break
                end
                push!(route, bestNode)
                incrementNVisited!(streetGraph, current, bestNode)
            end
        end
    end
    return Solution(solution)
end
