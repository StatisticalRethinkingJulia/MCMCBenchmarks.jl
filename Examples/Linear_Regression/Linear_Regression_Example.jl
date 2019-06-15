using Revise,MCMCBenchmarks,Distributed
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
  include(joinpath($path,
    "../../Models/Linear_Regression/Linear_Regression_Models.jl"))
end

#run this on primary processor to create tmp folder
include(joinpath(path,
  "../../Models/Linear_Regression/Linear_Regression_Models.jl"))

@everywhere Turing.turnprogress(false)
#set seeds on each processor
seeds = (939388,39884,28484,495858,544443)
for (i,seed) in enumerate(seeds)
    @fetch @spawnat i Random.seed!(seed)
end
#create a sampler object or a tuple of sampler objects

#Note that AHMC and DynamicNUTS do not work together due to an
# error in MCMCChains: https://github.com/TuringLang/MCMCChains.jl/issues/101

samplers=(
  CmdStanNUTS(CmdStanConfig,ProjDir),
  AHMCNUTS(AHMCregression,AHMCconfig),
  DHMCNUTS(sampleDHMC,2000))
  #DNNUTS(DNregression,DNconfig))

stanSampler = CmdStanNUTS(CmdStanConfig,ProjDir)
#Initialize model files for each instance of stan
initStan(stanSampler)

#Number of data points
Nd = [10, 100, 1000]

#Number of coefficients
Nc = 3

#Number of simulations
Nreps = 50

options = (Nsamples=2000,Nadapt=1000,delta=.8,Nd=Nd,Nc=Nc)

#perform the benchmark
results = pbenchmark(samplers,simulateRegression,Nreps;options...)

#save results
save(results,ProjDir)

pyplot()
cd(pwd)
dir = "results/"

#Plot parameter recovery
parms = Dict(:B0=>1,Symbol("B[1]")=>.5,Symbol("B[2]")=>.5,Symbol("B[3]")=>.5,:sigma=>1)
recoveryPlots = plotrecovery(results,parms,(:sampler,:Nd);save=true,dir=dir)

#Plot mean run time as a function of number of data points (Nd) for each sampler
meantimePlot = plotsummary(results,:Nd,:time,(:sampler,);save=true,dir=dir,yscale=:log10)

#Plot mean allocations as a function of number of data points (Nd) for each sampler
meanallocPlot = plotsummary(results,:Nd,:allocations,(:sampler,);save=false,dir=dir,yscale=:log10,
  ylabel="Allocations (log scale)")

#Plot mean ess per second of number of data points (Nd) for each sampler
essPS = plotsummary(results,:Nd,:ess_ps,(:sampler,);save=true,dir=dir)

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
