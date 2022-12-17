```@meta
CurrentModule = C25Challenge
```

# C25Challenge

Documentation for [C25Challenge](https://github.com/willseiple/C25Challenge.jl).



## Usage

```julia
using C25Challenge
problem = Problem()
solution = series_solver(problem)
```

## Algorithm


We have 3 different approaches.

### Greedy Approach

For our initial implementation, we started with a naive greedy algorithm optimizing for a heuristic representing rate of score accrual. 

This heuristic works as follows: if a certain edge has not been visited, its value is distance / duration (speed limit), otherwise we multiply this value by k^(number of times visited) (we chose a value of 0.3 for k).

We initially made visited edges worth 0, but found that this is not very useful in the case where all immediate edges have been visited, and it is reasonable to choose the road least traveled (or one with over 1/k times that road's speed limit, which may propel the car into a different part of the city).

For each car, we calculate its entire path by selecting the edge that maximizes our heuristic. We then increment the number of times that edge has been visited and repeat. This algorithm runs in O(cE) time, where c is the number of cars and E is the average number of roads taken for any car (total time allowed / average time per road), so with 8 cars O(E). This resulted in fairly mediocre results, with cars failing to explore many regions of the city, but was extremely fast.


### Greedy Lookahead Approach in Series

We then upgraded our design by implementing a lookahead into a very similar algorithm. Instead of selecting the next edge for a car at a given junction by choosing the road that maximized our heuristic, we chose the first edge in the path of a specified length d (in number of junctions) with the highest average heuristic. Our implementation of the lookahead at a given junction queries neighboring junctions for the cumulative heuristic of a path of length d-1 from that junction, and chooses the junction with the highest total cumulative heuristic + the heuristic resulting in traversing that edge. Our algorithm then takes one step to that junction and repeats. For each car, this algorithm takes E steps, where E is the average number of roads taken for any car (total time allowed / average time per road), and at each step it carries out a lookahead of time V^d, where V is the average number of neighbors at a given junction, and d is the depth of the lookahead (constant). This gives us a complexity of O(cEV^d), or with 8 cars, O(EV^d). Using this algorithm, we were able to reach a distance of 1,820,000 at a depth of 8, with impressive coverage of the city and logical car behavior when inspected visually.

### Greedy Lookahead Approach in Parallel

We tried a number of augmentations to the lookahead algorithm, including parallelizing (sort of) the progress of each of the cars. Instead of allowing the cars to traverse the graph all in one turn, we had the cars one step on each turn. This algorithm has the same runtime as the previous series approach, but led to a slight improvement, as the cars gained more information about the actions of the other cars as time went on. We were able to reach a total distance of 1,852,994 at a depth of 8.


## Index

```@index
```

```@autodocs
Modules = [C25Challenge]
```