using Revise, MCMCBenchmarks, Distributed

Nchains = 4
setprocs(Nchains)

ProjDir = @__DIR__
cd(ProjDir)

isdir("tmp") && rm("tmp", recursive=true)
mkdir("tmp")
!isdir("results") && mkdir("results")
path = pathof(MCMCBenchmarks)

@everywhere begin
  using MCMCBenchmarks
  # Model and configuration patterns for each sampler are located in a
  # seperate model file.
  include(joinpath($path,
    "../../Models/Hierarchical_Poisson/Hierarhical_Poisson_Models.jl"))
end

# Run this on primary processor to create tmp folder
include(joinpath(path,
  "../../Models/Hierarchical_Poisson/Hierarhical_Poisson_Models.jl"))

@everywhere Turing.turnprogress(false)
#set seeds on each processor
seeds = (939388,39884,28484,495858,544443)
for (i,seed) in enumerate(seeds)
    @fetch @spawnat i Random.seed!(seed)
end

# Create a sampler object or a tuple of sampler objects
samplers=(
  CmdStanNUTS(CmdStanConfig, ProjDir),
  AHMCNUTS(AHMCpoisson, AHMCconfig),
  DHMCNUTS(sampleDHMC),
)

stanSampler = CmdStanNUTS(CmdStanConfig, ProjDir)

# Initialize model files for each instance of stan
initStan(stanSampler)

# Number of data points per unit
Nd = [1, 2, 5]

# Number of units in model
Ns = 10

# Number of simulations
Nreps = 25

options = (Nsamples=2000, Nadapt=1000, delta=.8, Nd=Nd, Ns=Ns)

# Perform the benchmark
results = pbenchmark(samplers, simulatePoisson, Nreps; options...)

# Save results
save(results, ProjDir)

# Make plots
include("plotting.jl")
