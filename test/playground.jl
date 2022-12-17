using C25Challenge

solution = series_solver(Problem(), 5)
solution = parallel_solver(Problem(), 6)
solution = random_parallel_solver(Problem(), 5)

compute_distance(solution), feasible_check(solution)
