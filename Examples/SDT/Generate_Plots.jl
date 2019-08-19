using MCMCBenchmarks,CSV

ProjDir = @__DIR__
cd(ProjDir)
folder = "2019_05_30T19_40_00"
results = CSV.read(string(ProjDir,"/results/",folder*"/results.csv"))

# Make plots
include("plotting.jl")
