module C25Challenge

using Graphs
using SimpleValueGraphs
using HashCode2014

export series_solver
export parallel_solver
export random_parallel_solver

export EdgeWeight
export StreetGraph
export Problem

# export read_city
# export plot_streets

export feasible_check
export compute_distance

include("structs/EdgeWeight.jl")
include("structs/graph.jl")

include("util/helpers.jl")
include("util/evaluate.jl")

include("solvers/series.jl")
include("solvers/parallel.jl")
include("solvers/random.jl")

end
