using MCMCBenchmarks,Distributed
Nchains=4
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
  include(joinpath($path, "../../Models/LBA/LBA_Models.jl"))
  include(joinpath($path, "../../Models/LBA/LinearBallisticAccumulator.jl"))
end

#run this on primary processor to create tmp folder
include(joinpath(path, "../../Models/LBA/LBA_Models.jl"))
include(joinpath(path, "../../Models/LBA/LinearBallisticAccumulator.jl"))

@everywhere turnprogress(false)
#set seeds on each processor
seeds = (939388,39884,28484,495858,544443)
for (i,seed) in enumerate(seeds)
    @fetch @spawnat i Random.seed!(seed)
end

@everywhere Turing.turnprogress(false)

stanSampler = CmdStanNUTS(CmdStanConfig,ProjDir)
#Initialize model files for each instance of stan
initStan(stanSampler)

#create a sampler object or a tuple of sampler objects
samplers=(
  CmdStanNUTS(CmdStanConfig,ProjDir),
  AHMCNUTS(AHMClba,AHMCconfig),
  DHMCNUTS(sampleDHMC)
)

#Number of data points
Nd = [10, 50, 200]

#Number of simulations
Nreps = 50

options = (Nsamples=2000,Nadapt=1000,delta=.8,Nd=Nd)
#perform the benchmark
results = pbenchmark(samplers,simulateLBA,Nreps;options...)

#save results
save(results,ProjDir)

# Make plots
include("primary_plots.jl")
