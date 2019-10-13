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
        "Example"=>"example.md",
        "Benchmark Results"=>"benchmarks.md"
        ]
)

mkpath("docs/build/benchmarks/images")
cp("Examples/Gaussian/results/summary_time.png",
   "docs/build/benchmarks/images/summary_time.png")

deploydocs(
    repo = "github.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl.git",
)
