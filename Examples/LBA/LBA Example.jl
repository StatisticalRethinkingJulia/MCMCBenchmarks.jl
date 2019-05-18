using Revise,MCMCBenchmarks

#Model and configuration patterns for each sampler are located in a
#seperate model file.

Turing.turnprogress(false)
include("../../Models/LBA/LBA_Models.jl")
include("../../Models/LBA/LinearBallisticAccumulator.jl")

Random.seed!(551158015)

ProjDir = @__DIR__
cd(ProjDir)

#create a sampler object or a tuple of sampler objects
samplers=(
  CmdStanNUTS(CmdStanConfig,ProjDir),
  AHMCNUTS(AHMClba,AHMCconfig))
  #DNNUTS(DNlba,DNconfig))
  #DHMCNUTS(sampleDHMC,2000))

#Number of data points
Nd = [10, 50, 200]

#Number of simulations
Nreps = 50

#perform the benchmark
results = benchmark(samplers,simulateLBA,Nd, Nreps)

timeDf = by(results,[:Nd,:sampler],:time=>mean)
gr()#Might want to use pyplot() because it has better formatting and less crowding
Ns = length(Nd)
p1=@df timeDf plot(:Nd,:time_mean,group=:sampler,xlabel="Number of data points",
    ylabel="Mean Time (seconds)",grid=false)
p2=@df results density(:A_ess,group=(:sampler,:Nd),grid=false,xlabel="A ESS",ylabel="Density",
    xlims=(0,1000),layout=(Ns,1),fill=(0,.5),width=1.5)
p3=@df results density(:tau_ess,group=(:sampler,:Nd),grid=false,xlabel="tau ESS",ylabel="Density",
   xlims=(0,1000),layout=(Ns,1),fill=(0,.5),width=1.5)
p4=@df results density(:time,group=(:sampler,:Nd),grid=false,xlabel="Time",ylabel="Density",
   xlims=(0,50),layout=(Ns,1),fill=(0,.5),width=1)
p5=@df results density(:A_r_hat,group=(:sampler,:Nd),grid=false,xlabel="A R_hat",ylabel="Density",
    layout=(Ns,1),fill=(0,.5),width=1.5)
p6=@df results density(:tau_r_hat,group=(:sampler,:Nd),grid=false,xlabel="tau R_hat",ylabel="Density",
    layout=(Ns,1),fill=(0,.5),width=1.5)
p7=@df results scatter(:epsilon,:A_ess,group=(:sampler,:Nd),grid=false,xlabel="Epsilon",ylabel="A ESS",
    layout=(Ns,1))
p8=@df results scatter(:epsilon,:tau_ess,group=(:sampler,:Nd),grid=false,xlabel="Epsilon",ylabel="Tau ESS",
    layout=(Ns,1))
p9=@df results density(:k_ess,group=(:sampler,:Nd),grid=false,xlabel="k ESS",ylabel="Density",
    xlims=(0,1000),layout=(Ns,1),fill=(0,.5),width=1.5)
p10=@df results scatter(:epsilon,:k_ess,group=(:sampler,:Nd),grid=false,xlabel="Epsilon",ylabel="k ESS",
    layout=(Ns,1))

!isdir("results") && mkdir("results")
savefig(p1,"./results/Mean Time.pdf")
savefig(p2,"./results/A ESS Dist.pdf")
savefig(p3,"./results/Tau ESS Dist.pdf")
savefig(p4,"./results/Time Dist.pdf")
savefig(p5,"./results/A rhat Dist.pdf")
savefig(p6,"./results/Tau rhat Dist.pdf")
savefig(p7,"./results/A Epsilon Scatter.pdf")
savefig(p8,"./results/Tau Epsilon Scatter.pdf")
savefig(p9,"./results/k ESS Scatter.pdf")
savefig(p10,"./results/k Epsilon Scatter.pdf")

timeDf
