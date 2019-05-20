using MCMCBenchmarks

#Model and configuration patterns for each sampler are located in a
#seperate model file.
include("../../Models/LinearRegression/lt.jl")

Random.seed!(2202184)

Turing.turnprogress(false)

ProjDir = @__DIR__
pwd = pwd()
cd(ProjDir)

#create a sampler object or a tuple of sampler objects

#Note that AHMC and DynamicNUTS do not work together due to an
# error in MCMCChains: https://github.com/TuringLang/MCMCChains.jl/issues/101

samplers=(
  #CmdStanNUTS(CmdStanConfig,ProjDir),
  #AHMCNUTS(AHMCGaussian,AHMCconfig),
  DHMCNUTS(sampleDHMC,2000))
  #DNNUTS(DNGaussian,DNconfig))

#Number of data points
Nd = [10, 100, 1000]

#Number of simulations
Nreps = 50

#perform the benchmark
results = benchmark(samplers,GaussianGen,Nd, Nreps)

#pyplot()
cd(pwd)
dir = "results/"
#Plot mean run time as a function of number of data points (Nd) for each sampler
summaryPlots = plotsummary(results,:Nd,:time,(:sampler,);save=true,dir=dir)

#Plot density of effective sample size as function of number of data points (Nd) for each sampler
essPlots = plotdensity(results,:ess,(:sampler,:Nd);save=true,dir=dir)

#Plot density of rhat as function of number of data points (Nd) for each sampler
rhatPlots = plotdensity(results,:r_hat,(:sampler,:Nd);save=true,dir=dir)

#Plot density of time as function of number of data points (Nd) for each sampler
timePlots = plotdensity(results,:time,(:sampler,:Nd);save=true,dir=dir)

#Scatter plot of epsilon and effective sample size as function of number of data points (Nd) for each sampler
scatterPlots = plotscatter(results,:epsilon,:ess,(:sampler,:Nd);save=true,dir=dir)
