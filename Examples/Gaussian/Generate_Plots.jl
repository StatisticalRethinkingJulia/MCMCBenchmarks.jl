using MCMCBenchmarks,CSV

ProjDir = @__DIR__
cd(ProjDir)

# Load results
folder = "2019_10_14T07_44_00/"
results = CSV.read(ProjDir * "/results/" * folder * "results.csv")

# Make plots
include("primary_plots.jl")
