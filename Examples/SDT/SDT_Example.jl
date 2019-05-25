using MCMCBenchmarks

#Model and configuration patterns for each sampler are located in a
#seperate model file.
include("../../Models/SDT/SDT.jl")
include("../../Models/SDT/SDT_Functions.jl")
#load benchmarking configuration
include("../../benchmark_configurations/Vary_Data_size.jl")
Random.seed!(31854025)

turnprogress(false)

ProjDir = @__DIR__
cd(ProjDir)

samplers=(CmdStanNUTS(CmdStanConfig,ProjDir),
    AHMCNUTS(AHMC_SDT,AHMCconfig),
    #DNNUTS(DN_SDT,DNconfig)
    DHMCNUTS(sampleDHMC,2000))

#Number of data points
Nd = [10,100,1000]

#Number of simulations
Nreps = 100

#perform the benchmark
results = benchmark(samplers,simulateSDT,Nd)

#pyplot()
cd(pwd)
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
