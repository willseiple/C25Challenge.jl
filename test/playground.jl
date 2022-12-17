using C25Challenge

solution = series_solver(Problem(), 5)
solution = parallel_solver(Problem())

compute_distance(solution)
feasible_check(solution)
