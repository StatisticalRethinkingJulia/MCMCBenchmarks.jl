pyplot()
cd(pwd)
dir = "results/"
font_size = 18

# Plot mean run time as a function of number of data points (Nd) for each sampler
meantimePlot = plotsummary(results, :Nd, :time, (:sampler,); save=true, dir=dir, yscale=:log10,
  xaxis=font(font_size), yaxis=font(font_size), legendfont = 12, size=(500,500), width=3
  )

# Plot mean allocations as a function of number of data points (Nd) for each sampler
meanallocPlot = plotsummary(results, :Nd, :allocations, (:sampler,); save=true, dir=dir, yscale=:log10,
  ylabel="Allocations (log scale)", xaxis=font(font_size), yaxis=font(font_size), legendfont = 12, size=(500,500), width=3
)

# Plot density of effective sample size as function of number of data points (Nd) for each sampler
essPlots = plotdensity(results, :ess, (:sampler, :Nd); save=true, dir=dir,
xaxis=font(font_size), yaxis=font(font_size), legendfont = 12, size=(700,700), width=3
)
