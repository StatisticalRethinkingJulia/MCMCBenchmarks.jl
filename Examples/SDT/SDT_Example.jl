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
  include(joinpath($path, "../../Models/SDT/SDT.jl"))
  include(joinpath($path, "../../Models/SDT/SDT_Functions.jl"))
end
include(joinpath(path, "../../Models/SDT/SDT.jl"))
include(joinpath(path, "../../Models/SDT/SDT_Functions.jl"))
#Model and configuration patterns for each sampler are located in a
#seperate model file.

@everywhere Turing.turnprogress(false)
#set seeds on each processor
seeds = (939388,39884,28484,495858,544443)
for (i,seed) in enumerate(seeds)
    @fetch @spawnat i Random.seed!(seed)
end

stanSampler = CmdStanNUTS(CmdStanConfig,ProjDir)
#Initialize model files for each instance of stan
initStan(stanSampler)
#Compile stan model

samplers=(CmdStanNUTS(CmdStanConfig,ProjDir),
    AHMCNUTS(AHMC_SDT,AHMCconfig),
    DHMCNUTS(sampleDHMC,2000)
)

#Number of data points
Nd = [10,100,1000]

#Number of simulations
Nreps = 100

options = (Nsamples=2000,Nadapt=1000,delta=.8,Nd=Nd)
#perform the benchmark
results = pbenchmark(samplers,simulateSDT,Nreps;options...)

#save results
save(results,ProjDir)

# Make plots
include("primary_plots.jl")
