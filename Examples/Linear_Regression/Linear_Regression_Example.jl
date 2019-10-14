using Revise,MCMCBenchmarks,Distributed
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
  #Model and configuration patterns for each sampler are located in a
  #seperate model file.
  include(joinpath($path,
    "../../Models/Linear_Regression/Linear_Regression_Models.jl"))
end

#run this on primary processor to create tmp folder
include(joinpath(path,
  "../../Models/Linear_Regression/Linear_Regression_Models.jl"))

@everywhere Turing.turnprogress(false)
#set seeds on each processor
seeds = (939388, 39884, 28484, 495858, 544443)
for (i,seed) in enumerate(seeds)
    @fetch @spawnat i Random.seed!(seed)
end
#create a sampler object or a tuple of sampler objects

samplers=(
  CmdStanNUTS(CmdStanConfig, ProjDir),
  AHMCNUTS(AHMCregression, AHMCconfig),
  DHMCNUTS(sampleDHMC)
)

stanSampler = CmdStanNUTS(CmdStanConfig, ProjDir)
#Initialize model files for each instance of stan
initStan(stanSampler)

#Number of data points
Nd = [10, 100, 1000]

#Number of coefficients
Nc = [2, 3]

#Number of simulations
Nreps = 50

options = (Nsamples=2000, Nadapt=1000, delta=.8, Nd=Nd, Nc=Nc)
#perform the benchmark
results = pbenchmark(samplers, simulateRegression, Nreps; options...)

#save results
save(results, ProjDir)

# Make plots
include("primary_plots.jl")
