using Documenter, MCMCBenchmarks

function add_image(folder,file)
    mkpath("docs/build/benchmarks/images/"*folder)
    cp("Examples/"*folder*"/results/"*file,
       "docs/build/benchmarks/images/"*folder*"/"*file)
end

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

folders = ["Gaussian","Gaussian","Gaussian"]
files = ["summary_time.png","summary_allocations.png","density_mu_ess.png"]

[add_image(folder,file) for (folder,file) in zip(folders,files)]


deploydocs(
    repo = "github.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl.git",
)
