using MCMCBenchmarks

#Model and configuration patterns for each sampler are located in a
#seperate model file.
path = pathof(MCMCBenchmarks)
include(joinpath(path,"../../Models/LinearRegression/LinearRegression_Models.jl"))
#load benchmarking configuration
include(joinpath(path,"../../benchmark_configurations/Vary_Data_Coefs.jl"))

Random.seed!(2202184)

Turing.turnprogress(false)

ProjDir = @__DIR__
cd(ProjDir)

#create a sampler object or a tuple of sampler objects

#Note that AHMC and DynamicNUTS do not work together due to an
# error in MCMCChains: https://github.com/TuringLang/MCMCChains.jl/issues/101

samplers=(
  #CmdStanNUTS(CmdStanConfig,ProjDir),
  #DHMCNUTS(sampleDHMC,2000)
  #DNNUTS(DNregression,DNconfig)
  AHMCNUTS(AHMCregression,AHMCconfig))

#Number of data points
Nd = [10,100]

#Number of coefficients
Nc = [2,5]

#Number of simulations
Nreps = 50

#perform the benchmark
results = benchmark(samplers,simulateRegression,Nd,Nc,Nreps)

#pyplot()
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
