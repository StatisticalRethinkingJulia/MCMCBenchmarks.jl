using Documenter, MCMCBenchmarks

makedocs(
    modules = [MCMCBenchmarks],
    format = :html,
    checkdocs = :exports,
    sitename = "MCMCBenchmarks.jl",
    pages = Any["index.md"]
)

deploydocs(
    repo = "github.com/goedman/MCMCBenchmarks.jl.git",
)
