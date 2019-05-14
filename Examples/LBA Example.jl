using MCMCBenchmarks

#Model and configuration patterns for each sampler are located in a
#seperate model file.
include("../Models/LBA_Models.jl")
include("LinearBallisticAccumulator.jl")

Random.seed!(551158015)

ProjDir = @__DIR__
cd(ProjDir)

#create a sampler object or a tuple of sampler objects
samplers=(CmdStanNUTS(CmdStanConfig,ProjDir),AHMCNUTS(AHMClba,AHMCconfig),
    DHMCNUTS(sampleDHMC,2000))#,DNNUTS(DNlba,DNconfig))

#Number of data points
Nd = [10,100,500]

#perform the benchmark
results = benchmark(samplers,simulateLBA,Nd)

timeDf = by(results,[:Nd,:sampler],:time=>mean)
gr()#Might want to use pyplot() because it has better formatting and less crowding
Ns = length(Nd)
p1=@df timeDf plot(:Nd,:time_mean,group=:sampler,xlabel="Number of data points",
    ylabel="Mean Time (seconds)",grid=false)
p2=@df results density(:mu_ess,group=(:sampler,:Nd),grid=false,xlabel="Mu ESS",ylabel="Density",
    xlims=(0,1000),layout=(Ns,1),fill=(0,.5),width=1.5)
p3=@df results density(:sigma_ess,group=(:sampler,:Nd),grid=false,xlabel="Sigma ESS",ylabel="Density",
   xlims=(0,1000),layout=(Ns,1),fill=(0,.5),width=1.5)
p4=@df results density(:time,group=(:sampler,:Nd),grid=false,xlabel="Time",ylabel="Density",
   xlims=(0,10),layout=(Ns,1),fill=(0,.5),width=1)
p5=@df results density(:mu_r_hat,group=(:sampler,:Nd),grid=false,xlabel="Mu r̂",ylabel="Density",
    layout=(Ns,1),fill=(0,.5),width=1.5)
p6=@df results density(:sigma_r_hat,group=(:sampler,:Nd),grid=false,xlabel="Sigma r̂",ylabel="Density",
    layout=(Ns,1),fill=(0,.5),width=1.5)
p7=@df results scatter(:epsilon,:mu_ess,group=(:sampler,:Nd),grid=false,xlabel="Epsilon",ylabel="Mu ESS",
    layout=(Ns,1))
p8=@df results scatter(:epsilon,:sigma_ess,group=(:sampler,:Nd),grid=false,xlabel="Epsilon",ylabel="Sigma ESS",
    layout=(Ns,1))

savefig(p1,"Mean Time.pdf")
savefig(p2,"Mu ESS Dist.pdf")
savefig(p3,"Sigma ESS Dist.pdf")
savefig(p4,"Time Dist.pdf")
savefig(p5,"Mu rhat Dist.pdf")
savefig(p6,"Sigma rhat Dist.pdf")
savefig(p7,"Mu Epsilon Scatter.pdf")
savefig(p8,"Sigma Epsilon Scatter.pdf")
