pyplot()
cd(pwd)
dir = "results/"

# Plot mean run time as a function of number of data points (Nd) for each sampler
meantimePlot = plotsummary(results, :Nd, :time, (:sampler, :Nc); save=true, dir=dir, yscale=:log10)

# Plot mean allocations as a function of number of data points (Nd) for each sampler
meanallocPlot = plotsummary(results, :Nd, :allocations, (:sampler, :Nc); save=true, dir=dir, yscale=:log10,
  ylabel="Allocations (log scale)"
)

# Plot density of effective sample size as function of number of data points (Nd) for each sampler
essPlots = plotsummary(results, :Nd, :ess, (:sampler, :Nc); save=true, dir=dir)
