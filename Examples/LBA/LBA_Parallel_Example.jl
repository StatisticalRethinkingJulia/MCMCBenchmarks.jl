using MCMCBenchmarks, Distributed

setprocs(4)

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
  include(joinpath($path,"../../Models/LBA/LBA_Models.jl"))
  include(joinpath($path,"../../Models/LBA/LinearBallisticAccumulator.jl"))
  #load benchmarking configuration
  include(joinpath($path, "../../benchmark_configurations/Vary_Data_size.jl"))
end

#run this on primary processor to create tmp folder
include(joinpath(path,"../../Models/LBA/LBA_Models.jl"))
include(joinpath(path,"../../Models/LBA/LinearBallisticAccumulator.jl"))
#load benchmarking configuration
include(joinpath(path, "../../benchmark_configurations/Vary_Data_size.jl"))

setSeeds!(8945205,112585,650054,5502)

@everywhere Turing.turnprogress(false)

stanSampler = CmdStanNUTS(CmdStanConfig,ProjDir)
#Initialize model files for each instance of stan
initStan(stanSampler)
#Compile stan model
compileStanModel(stanSampler,simulateLBA)
#create a sampler object or a tuple of sampler objects

#Note that AHMC and DynamicNUTS do not work together due to an
# error in MCMCChains: https://github.com/TuringLang/MCMCChains.jl/issues/101

samplers=(
  CmdStanNUTS(CmdStanConfig,ProjDir),
  AHMCNUTS(AHMClba,AHMCconfig),
  #DNNUTS(DNGaussian,DNconfig),
  DHMCNUTS(sampleDHMC,2000))


#Number of data points
Nd = [10,20,50]

#Number of simulations
Nreps = 50

#perform the benchmark
results = pbenchmark(samplers,simulateLBA,Nd,Nreps)
#pyplot()
dir = "results/"
#Plot mean run time as a function of number of data points (Nd) for each sampler
meantimePlot = plotsummary(results,:Nd,:time,(:sampler,);save=true,dir=dir)

#Plot mean allocations as a function of number of data points (Nd) for each sampler
meanallocPlot = plotsummary(results,:Nd,:allocations,(:sampler,);save=true,dir=dir,yscale=:log10,
  ylabel="Allocations (log scale)")

#Plot density of effective sample size as function of number of data points (Nd) for each sampler
essPlots = plotdensity(results,:ess,(:sampler,:Nd);save=true,dir=dir)

#Plot density of rhat as function of number of data points (Nd) for each sampler
rhatPlots = plotdensity(results,:r_hat,(:sampler,:Nd);save=true,dir=dir)

#Plot density of time as function of number of data points (Nd) for each sampler
timePlots = plotdensity(results,:time,(:sampler,:Nd);save=true,dir=dir)

#Plot density of gc time percent as function of number of data points (Nd) for each sampler
gcPlots = plotdensity(results,:gcpercent,(:sampler,:Nd);save=true,dir=dir)

#Plot density of memory allocations as function of number of data points (Nd) for each sampler
memPlots = plotdensity(results,:allocations,(:sampler,:Nd);save=true,dir=dir,xscale=:log10,
  xlabel="Allocations (log scale)")

#Plot density of megabytes allocated as function of number of data points (Nd) for each sampler
megPlots = plotdensity(results,:megabytes,(:sampler,:Nd);save=true,dir=dir)

#Scatter plot of epsilon and effective sample size as function of number of data points (Nd) for each sampler
scatterPlots = plotscatter(results,:epsilon,:ess,(:sampler,:Nd);save=true,dir=dir)