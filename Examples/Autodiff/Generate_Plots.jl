using MCMCBenchmarks, CSV

ProjDir = @__DIR__
cd(ProjDir)

# Load results
folder = "results/2019_10_14T13_55_00/"
results = CSV.read(folder * "results.csv", copycols=true)
allowmissing!(results)

# Make plots
include("primary_plots.jl")
