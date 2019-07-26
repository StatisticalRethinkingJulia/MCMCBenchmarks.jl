using Documenter, MCMCBenchmarks

makedocs(
    modules = [MCMCBenchmarks],
    checkdocs = :exports,
    authors = "Christopher R. Fisher, Rob J Goedman",
    sitename = "StatisticalRethinkingJulia/MCMCBenchmarks.jl",
    pages = Any["index.md"]
)

deploydocs(
    #repo = "github.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl.git",
    https://github.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl/tree/docs_branch,
)
