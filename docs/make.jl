using Documenter, MCMCBenchmarks

makedocs(
    modules = [MCMCBenchmarks],
    checkdocs = :exports,
    format = :html,
    clean = true,
    authors = "Christopher R. Fisher, Rob J Goedman",
    sitename = "StatisticalRethinkingJulia/MCMCBenchmarks.jl",
    pages = Any[
        "Home"=>"index.md",
        "Purpose"=>"purpose.md",
        "Design"=>"design.md",
        "Functions"=>"functions.md",
        "Example"=>"example.md"
        ]
)
