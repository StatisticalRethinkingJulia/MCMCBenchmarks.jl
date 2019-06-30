using MCMCBenchmarks,CSV

ProjDir = @__DIR__
cd(ProjDir)

path = joinpath(pathof(MCMCBenchmarks),"../../Examples/Hierarchical_Poisson/results/")

folder = "2019_06_15T14_20_00/"
results = CSV.read(path*folder*"results.csv")

dir = "results/"

#Plot parameter recovery
parms = parms = Dict(:a0=>1,:a1=>.5,:a0_sig=>.5)
recoveryPlots = plotrecovery(results,parms,(:sampler,:Nd);save=true,dir=dir)

#Plot mean run time as a function of number of data points (Nd) for each sampler
meantimePlot = plotsummary(results,:Nd,:time,(:sampler,:Ns,);save=true,dir=dir,yscale=:log10)

#Plot mean allocations as a function of number of data points (Nd) for each sampler
meanallocPlot = plotsummary(results,:Nd,:allocations,(:sampler,:Ns);save=false,dir=dir,yscale=:log10,
  ylabel="Allocations (log scale)")

#Plot mean ess per second of number of data points (Nd) for each sampler
essPS = plotsummary(results,:Nd,:ess_ps,(:sampler,:Ns);save=true,dir=dir)

#Plot density of effective sample size as function of number of data points (Nd) for each sampler
essPlots = plotdensity(results,:ess,(:sampler,:Nd);save=true,dir=dir)

#Plot density of rhat as function of number of data points (Nd) for each sampler
rhatPlots = plotdensity(results,:r_hat,(:sampler,:Nd,:Ns);save=true,dir=dir)

#Plot density of time as function of number of data points (Nd) for each sampler
timePlots = plotdensity(results,:time,(:sampler,:Nd,:Ns);save=true,dir=dir)

#Plot density of gc time percent as function of number of data points (Nd) for each sampler
gcPlots = plotdensity(results,:gcpercent,(:sampler,:Nd,:Ns);save=true,dir=dir)

#Plot density of memory allocations as function of number of data points (Nd) for each sampler
memPlots = plotdensity(results,:allocations,(:sampler,:Nd,:Ns);save=true,dir=dir,xscale=:log10,
  xlabel="Allocations (log scale)")

#Plot density of megabytes allocated as function of number of data points (Nd) for each sampler
megPlots = plotdensity(results,:megabytes,(:sampler,:Nd,:Ns);save=true,dir=dir)

#Scatter plot of epsilon and effective sample size as function of number of data points (Nd) for each sampler
scatterPlots = plotscatter(results,:epsilon,:ess,(:sampler,:Nd,:Ns);save=true,dir=dir)
