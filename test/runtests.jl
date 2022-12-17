using Aqua
using Documenter
using C25Challenge
using JuliaFormatter
using Test

DocMeta.setdocmeta!(C25Challenge, :DocTestSetup, :(using C25Challenge); recursive=true)

@testset verbose = true "C25Challenge.jl" begin
    @testset verbose = true "Code quality (Aqua.jl)" begin
        Aqua.test_all(C25Challenge; ambiguities=false)
    end

    @testset verbose = true "Code formatting (C25Challenge.jl)" begin
        @test format(C25Challenge; verbose=true, overwrite=true)
    end

    @testset verbose = true "Doctests (Documenter.jl)" begin
        doctest(C25Challenge)
    end

    @testset verbose = true "series_solver" begin
        solution = series_solver(Problem())
        city = read_city()
        @test feasible_check(solution) == is_feasible(solution, city)
        @test compute_distance(solution) == total_distance(solution, city)
    end
    @testset verbose = true "parallel_solver" begin
        solution = parallel_solver(Problem())
        city = read_city()
        @test feasible_check(solution) == is_feasible(solution, city)
        @test compute_distance(solution) == total_distance(solution, city)
    end
    @testset verbose = true "random_solver" begin
        solution = random_parallel_solver(Problem())
        city = read_city()
        @test feasible_check(solution) == is_feasible(solution, city)
        @test compute_distance(solution) == total_distance(solution, city)
    end
end
