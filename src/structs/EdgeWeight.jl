"""
    EdgeWeight

Stores the weight of an edge in a StreetGraph

# Fields
- `duration::Integer` : The duration to traverse the edge or street
- `rate::Float64`: The rate of taking the edge or street
- `nvisited::Float64`: The number of times the edge has been visited
"""
struct EdgeWeight
    duration::Integer
    rate::Float64
    nvisited::Integer

    EdgeWeight(s::Street) = new(s.duration, s.distance / s.duration, 0)
    EdgeWeight(d::Integer, r::Float64, n::Integer) = new(d, r, n)
end
