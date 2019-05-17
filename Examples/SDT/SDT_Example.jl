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

pyplot()
Ns = length(Nd)
p1=@df timeDf plot(:Nd,:time_mean,group=:sampler,xlabel="Number of data points",
    ylabel="Mean Time (seconds)",grid=false)
p2=@df results density(:d_ess,group=(:sampler,:Nd),grid=false,xlabel="d ESS",ylabel="Density",
    xlims=(0,1000),layout=(Ns,1),fill=(0,.5),width=1.5)
p3=@df results density(:c_ess,group=(:sampler,:Nd),grid=false,xlabel="c ESS",ylabel="Density",
   xlims=(0,1000),layout=(Ns,1),fill=(0,.5),width=1.5)
p4=@df results density(:time,group=(:sampler,:Nd),grid=false,xlabel="Time",ylabel="Density",
   layout=(Ns,1),fill=(0,.5),width=1)
p5=@df results density(:d_r_hat,group=(:sampler,:Nd),grid=false,xlabel="d r̂",ylabel="Density",
    layout=(Ns,1),fill=(0,.5),width=1.5)
p6=@df results density(:c_r_hat,group=(:sampler,:Nd),grid=false,xlabel="c r̂",ylabel="Density",
    layout=(Ns,1),fill=(0,.5),width=1.5)
p7=@df results scatter(:epsilon,:d_ess,group=(:sampler,:Nd),grid=false,xlabel="Epsilon",ylabel="d ESS",
    layout=(Ns,1))
p8=@df results scatter(:epsilon,:c_ess,group=(:sampler,:Nd),grid=false,xlabel="Epsilon",ylabel="c ESS",
    layout=(Ns,1))

savefig(p1,"Mean Time.pdf")
savefig(p2,"d ESS Dist.pdf")
savefig(p3,"c ESS Dist.pdf")
savefig(p4,"Time Dist.pdf")
savefig(p5,"d rhat Dist.pdf")
savefig(p6,"c rhat Dist.pdf")
savefig(p7,"d Epsilon Scatter.pdf")
savefig(p8,"c Epsilon Scatter.pdf")
