using C25Challenge
using Documenter

DocMeta.setdocmeta!(C25Challenge, :DocTestSetup, :(using C25Challenge); recursive=true)

makedocs(;
    modules=[C25Challenge],
    authors="Will Seiple <60242249+willseiple@users.noreply.github.com> and contributors",
    repo="https://github.com/willseiple/C25Challenge.jl/blob/{commit}{path}#{line}",
    sitename="C25Challenge.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://willseiple.github.io/C25Challenge.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/willseiple/C25Challenge.jl",
    devbranch="main",
)
