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

    #     @testset verbose = true "load StreetGraph " begin
    #         city = read_city()
    #         streetGraph = StreetGraph(city)

    #         @test streetGraph.N == 8
    #         @test streetGraph.start == 4517
    #         @test streetGraph.totalTime == 54000
    #     end
end
