using MCMCBenchmarks,CSV

ProjDir = @__DIR__
cd(ProjDir)

path = joinpath(pathof(MCMCBenchmarks),"../../Examples/Linear_Regression/results/")

folder = "2019_06_15T14_20_00/"
results = CSV.read(path*folder*"results.csv")

# Make plots
include("plotting.jl")
