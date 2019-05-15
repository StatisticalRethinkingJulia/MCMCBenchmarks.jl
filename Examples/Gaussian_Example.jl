using MCMCBenchmarks

#Model and configuration patterns for each sampler are located in a
#seperate model file.
include("../Models/Gaussian.jl")

Random.seed!(2202184)

turnprogress(false) #not working

ProjDir = @__DIR__
cd(ProjDir)

#create a sampler object or a tuple of sampler objects
#Note that AHMC and DynamicNUTS do not work together due to an error in MCMCChains:
#https://github.com/TuringLang/MCMCChains.jl/issues/101
samplers=(CmdStanNUTS(CmdStanConfig,ProjDir),AHMCNUTS(AHMCGaussian,AHMCconfig),
    DHMCNUTS(sampleDHMC,2000))#,DNNUTS(DNGaussian,DNconfig))

#Here is an example in which the number of data points is varied
#samplers is the sampler object or tuple of sampler objects
#simulate is the data generating function
#Nd is a vector of data sample sizes
#Nreps is the number of repetitions per simulation configuration. Default=100
function benchmark(samplers,simulate,Nd,Nreps=100)
    #Initialize an empty Dataframe to collect results
    results = DataFrame()
    #loop over the data sample sizes
    for nd in Nd
        #benchmark! is a general function that does the heavy lifting. It modifies the mcmc configuration,
        #runs the sampler and records the results. Since each sampler has a different interface and returns
        #output in a different form, each sampler requires its own object wrapper, as well as a method for modifyConfig!
        #runSampler, and updateResults!.
        #Keyword and option keyword arguments are leveraged to create a flexible framework and
        #are recorded in the results DataFrame
        #Nsamples, Nadapt and delta must be defined. These could be varied in a benchmark simulation also.
        benchmark!(samplers,results,simulate,Nreps;Nd=nd,Nsamples=2000,Nadapt=1000,delta=.8)
    end
    return results
end
#Number of data points
Nd = [10,100,500,1000]
#perform the benchmark
results = benchmark(samplers,GaussianGen,Nd)
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
