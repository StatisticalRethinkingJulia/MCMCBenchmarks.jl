using Documenter, MCMCBenchmarks

makedocs(
    modules = [MCMCBenchmarks],
    checkdocs = :exports, format = :html,
    authors = "Christopher R. Fisher, Rob J Goedman",
    sitename = "StatisticalRethinkingJulia/MCMCBenchmarks.jl",
    pages = Any[
        "Home"=>"index.md",
        "Purpose"=>"purpose.md",
        "Design"=>"design.md",
        "Example"=>"example.md",
        "Benchmark Results"=>"benchmarks.md"
        ]
)

deploydocs(
    repo = "github.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl.git",
)
