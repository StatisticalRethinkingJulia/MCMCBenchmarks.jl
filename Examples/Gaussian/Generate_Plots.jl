using MCMCBenchmarks,CSV

ProjDir = @__DIR__
cd(ProjDir)

# Load results
folder = "2019_08_18T16_26_00/"
results = CSV.read(ProjDir * "/results/" * folder * "results.csv")

# Make plots
include("plotting.jl")
