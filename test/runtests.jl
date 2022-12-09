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

    @testset verbose = true "My own tests" begin
        @test 1 + 1 == 2
    end
end
