using MCMCBenchmarks,Test

@testset "Plot Tests " begin
    cd( @__DIR__)

    results = CSV.read("Plot_Data.csv")

    #Plot parameter recovery
    recoveryPlots = plotrecovery(results, (mu=0, sigma=1), (:sampler, :Nd))
    @test typeof(recoveryPlots) ==  Array{Plots.Plot, 1}
    @test length(recoveryPlots) == 6

    #Plot mean run time as a function of number of data points (Nd) for each sampler
    meantimePlot = plotsummary(results, :Nd, :time, (:sampler, );yscale=:log10)
    @test typeof(meantimePlot) ==  Array{Plots.Plot, 1}
    @test length(meantimePlot) == 2

    #Plot mean allocations as a function of number of data points (Nd) for each sampler
    meanallocPlot = plotsummary(results, :Nd, :allocations, (:sampler, );yscale=:log10,
      ylabel="Allocations (log scale)")
    @test typeof(meanallocPlot) ==  Array{Plots.Plot, 1}
    @test length(meanallocPlot) == 1

    #Plot mean ess per second of number of data points (Nd) for each sampler
    essPS = plotsummary(results, :Nd, :ess_ps, (:sampler, ))
    @test typeof(essPS) ==  Array{Plots.Plot, 1}
    @test length(essPS) == 2

    #Plot density of effective sample size as function of number of data points (Nd) for each sampler
    essPlots = plotdensity(results, :ess, (:sampler, :Nd))
    @test typeof(essPlots) ==  Array{Plots.Plot, 1}
    @test length(essPlots) == 4

    #Plot density of rhat as function of number of data points (Nd) for each sampler
    rhatPlots = plotdensity(results, :r_hat, (:sampler, :Nd))
    @test typeof(rhatPlots) ==  Array{Plots.Plot, 1}
    @test length(rhatPlots) == 2

    #Plot density of time as function of number of data points (Nd) for each sampler
    timePlots = plotdensity(results, :time, (:sampler, :Nd))
    @test typeof(timePlots) ==  Array{Plots.Plot, 1}
    @test length(timePlots) == 2

    #Plot density of gc time percent as function of number of data points (Nd) for each sampler
    gcPlots = plotdensity(results, :gcpercent, (:sampler, :Nd))
    @test typeof(gcPlots) ==  Array{Plots.Plot, 1}
    @test length(gcPlots) == 1

    #Plot density of memory allocations as function of number of data points (Nd) for each sampler
    memPlots = plotdensity(results, :allocations, (:sampler, :Nd);xscale=:log10,
      xlabel="Allocations (log scale)")
    @test typeof(memPlots) ==  Array{Plots.Plot, 1}
    @test length(memPlots) == 1

    #Plot density of megabytes allocated as function of number of data points (Nd) for each sampler
    megPlots = plotdensity(results, :megabytes, (:sampler, :Nd))
    @test typeof(megPlots) ==  Array{Plots.Plot, 1}
    @test length(megPlots) == 1

    #Scatter plot of epsilon and effective sample size as function of number of data points (Nd) for each sampler
    scatterPlots = plotscatter(results, :epsilon, :ess, (:sampler, :Nd))
    @test typeof(scatterPlots) ==  Array{Plots.Plot, 1}
    @test length(scatterPlots) == 4
end
