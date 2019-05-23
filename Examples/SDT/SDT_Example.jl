using MCMCBenchmarks

#Model and configuration patterns for each sampler are located in a
#seperate model file.
include("../../Models/SDT/SDT.jl")
include("../../Models/SDT/SDT_Functions.jl")

Random.seed!(31854025)

turnprogress(false) #not working

ProjDir = @__DIR__
cd(ProjDir)

samplers=(CmdStanNUTS(CmdStanConfig,ProjDir),AHMCNUTS(AHMC_SDT,AHMCconfig))
    #DHMCNUTS(sampleDHMC,2000))#,DNNUTS(DN_SDT,DNconfig))

#Number of data points
Nd = [10,100,1000]
#perform the benchmark
results = benchmark(samplers,simulateSDT,Nd)
timeDf = by(results,[:Nd,:sampler],:time=>mean)


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

#Plot density of gc time percent as function of number of data points (Nd) for each sampler
gcPlots = plotdensity(results,:gcpercent,(:sampler,:Nd);save=true,dir=dir)

#Plot density of memory allocations as function of number of data points (Nd) for each sampler
gcPlots = plotdensity(results,:allocations,(:sampler,:Nd);save=true,dir=dir)

#Plot density of megabytes allocated as function of number of data points (Nd) for each sampler
gcPlots = plotdensity(results,:megabytes,(:sampler,:Nd);save=true,dir=dir)

#Scatter plot of epsilon and effective sample size as function of number of data points (Nd) for each sampler
scatterPlots = plotscatter(results,:epsilon,:ess,(:sampler,:Nd);save=true,dir=dir)
