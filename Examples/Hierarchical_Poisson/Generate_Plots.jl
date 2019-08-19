using MCMCBenchmarks, CSV

ProjDir = @__DIR__
cd(ProjDir)

# Load results
folder = "results/2019_08_18T18_43_00/"
results = CSV.read(folder * "results.csv", copycols=true)
allowmissing!(results)

# Make plots
include("Plotting.jl")
