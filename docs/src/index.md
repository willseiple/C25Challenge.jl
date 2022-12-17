```@meta
CurrentModule = C25Challenge
```

# C25Challenge

Documentation for [C25Challenge](https://github.com/willseiple/C25Challenge.jl).



## Usage

```julia
using C25Challenge
problem = Problem()
solution = parallel_solver(problem)
```

## Algorithm


### Greedy Approach

For our initial implementation, we created a naive greedy algorithm maximizing a heuristic representing rate of score accrual. 

This heuristic works as follows: if a certain edge has not been visited, its value is distance / duration (speed limit), otherwise we multiply this value by k^(number of times visited) (we chose a value of 0.3 for k). We initially made visited edges worth 0, but found that this is not very useful in the case where all immediate edges have been visited, and it is reasonable to choose the road least traveled (or one with over 1/k times that road's speed limit, which may propel the car into a different part of the city).

For each car, we calculate its entire path by selecting the edge that maximizes our heuristic. We then increment the number of times that edge has been visited and repeat. This algorithm runs in O(cE) time, where c is the number of cars and E is the average number of roads taken for any car (total time allowed / average time per road), so with 8 cars O(E). This resulted in fairly mediocre results, with cars failing to explore many regions of the city, but was extremely fast.

### Greedy Lookahead Approach in Series

We then upgraded our design by implementing a lookahead into a very similar algorithm. Instead of selecting the next edge for a car at a given junction by choosing the road that maximized our heuristic, we chose the first edge in the path of a specified length d (in number of junctions) with the highest average heuristic. Our implementation of the lookahead at a given junction queries neighboring junctions for the cumulative heuristic of a path of length d-1 from that junction, and chooses the junction with the highest total cumulative heuristic + the heuristic resulting in traversing that edge. Our algorithm then takes one step to that junction and repeats. For each car, this algorithm takes E steps, where E is the average number of roads taken for any car (total time allowed / average time per road), and at each step it carries out a lookahead of time V^d, where V is the average number of neighbors at a given junction, and d is the depth of the lookahead (constant). This gives us a complexity of O(cEV^d), or with 8 cars, O(EV^d). Using this algorithm, we were able to reach a distance of 1,820,000 at a depth of 8, with impressive coverage of the city and logical car behavior when inspected visually.

### Greedy Lookahead Approach in Parallel

We tried a number of augmentations to the lookahead algorithm, including parallelizing (sort of) the progress of each of the cars. Instead of allowing the cars to traverse the graph all in one turn, we had the cars take one step on each turn. This algorithm has the same runtime as the previous series approach, but led to a slight improvement, as the cars gained more information about the actions of the other cars as time went on. We were able to reach a total distance of 1,852,994 at a depth of 8.

### Greedy Lookahead Approach in Parallel with Random turns

We made one last adjustment, randomizing the number of steps each car could make per turn, by setting a percent chance the car could go again. We hypothesized this would improve performance by allowing each of the cars’ plans to be carried out to a greater extent, as in the previous approach it is possible that the cars would look ahead without the knowledge that another car was closer and may take that path first. However this approach gave very similar results to the previous algorithm without randomness, and could possibly be improved with a more complex method for randomization, or possibly by increasing the number of trials of the entire search and selecting the best performing result in a monte carlo style simulation.

### Other Considerations for Improvement

Among other ideas we played with was a heuristic that would take into account the depth of the lookahead search instead of simply finding the path with the highest average uniform heuristic value. This would weight closer streets more heavily, as they have a higher likelihood of being reached before another car in a parallel approach. In practice this was challenging to tune, and seemed to negate the benefits of the lookahead, however it could be useful in conjunction with a more effective random parallel algorithm. One other idea we considered was to run a lookahead for each of the other cars, then use this graph to run a lookahead for the current car, in order to find paths that any specific car is uniquely positioned to take advantage of.


### Upper Bound

When considering the upper bound, we came up with the following algorithm. We order the streets primarily by rate of travel (fastest first), and secondarily by distance (shortest first). We initialize two pointers. We iterate over the streets one at a time with the first pointer, keeping track of the total cumulative duration, and the duration of the streets in the current iteration, until the next street would result in going over the time limit. Then, we continue iterating with the second pointer until we find an edge with a duration less than the remaining available time (repeating this part until no more can be found), and marking these streets to be skipped by the first pointer. We repeat this for each car, resetting the second pointer but maintaining the first pointer, in order to see the maximum distance achievable if each car were always traveling on the current fastest, untravelled street that can be traversed within the time limit. This will maximize what is achievable in a feasible solution, and is an upper bound to the problem.


## Index

```@index
```

```@autodocs
Modules = [C25Challenge]
```