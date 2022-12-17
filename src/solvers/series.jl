"""
    series_solver(streetGraph::StreetGraph, lookahead=5)

A greedy algorithm that solves the problem by sending the cars one after another.

# Parameters
- `streetGraph`: The graph format of the City
- `lookahead`: The number of steps to lookahead
"""
function series_solver(streetGraph::StreetGraph, lookahead=5)
    (; graph, N, start, totalTime) = streetGraph
    # for logging
    total_distance = 0
    total_coverage = 0

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

                # remove later, for logging
                total_distance += duration * rate
                total_coverage += nvisited == 0 ? duration * rate : 0
            else
                break
            end
            print("Time: $time\r")
        end
        # solution[i] = route
        print("Car $car done.\n")
    end
    print("total_distance: $total_distance\n")
    print("total_coverage: $total_coverage\n\n")
    return Solution(solution)
end
