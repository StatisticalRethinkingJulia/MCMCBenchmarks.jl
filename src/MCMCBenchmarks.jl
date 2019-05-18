module MCMCBenchmarks

using Reexport

@reexport using Revise,Turing,MCMCBenchmarks,CmdStan,StatsPlots
@reexport using Statistics,DataFrames,Random,Parameters,DynamicHMC
@reexport using LogDensityProblems, TransformVariables, MCMCDiagnostics
@reexport using BenchmarkTools, AdvancedHMC, ForwardDiff

include("plotting.jl")

abstract type MCMCSampler end

"""
AdvancedHMC NUTS

* `model`: model function that accepts data
* `config`: sampler configution settings
"""
mutable struct AHMCNUTS{T1,T2} <: MCMCSampler
    model::T1
    config::T2
end

"""
CmdStan NUTS

* `model`: model configuration
* `dir`: probject directory
"""
mutable struct CmdStanNUTS{T1} <: MCMCSampler
    model::T1
    dir::String
end

"""
DynamicHMC NUTS

* `model`: model function that accepts data
* `config`: sampler configution settings
"""
mutable struct DHMCNUTS{T1,T2} <: MCMCSampler
    model::T1
    Nsamples::T2
end

"""
DynamicNUTS NUTS

* `model`: model function that accepts data
* `config`: sampler configution settings
"""
mutable struct DNNUTS{T1,T2} <: MCMCSampler
    model::T1
    config::T2
end

"""
Primary function that performs mcmc benchmark repeatedly on a set of samplers
and records the results.
* 'sampler': tuple of sampler objects
* `results`: DataFrame containing benchmark results
* `simulate`: data generating function
* `Nreps`: number of repetitions for a given set of simulation parameters. Default = 100
* `kwargs`: optional keyword arguments that are passed to modifyConfig!, updateResults! and
runSampler, providing flexibility in benchmark simulations.
"""
function benchmark!(samplers,results,simulate,Nreps=100;kwargs...)
    for rep in 1:Nreps
      data = simulate(;kwargs...)
      for s in samplers
          modifyConfig!(s;kwargs...)
          println("\nSampler: $(typeof(s))")
          println("Simulation: $simulate")
          println("No of obs: $(kwargs[1])")
          println("Repetition: $rep of $Nreps\n")
          t = @elapsed chn = runSampler(s,data;kwargs...)
          updateResults!(s,t,results,chn;kwargs...)
      end
    end
    return results
end

function benchmark!(sampler::T,results,simulate,Nreps=100;kwargs...) where {T<:MCMCSampler}
    return benchmark!((sampler,),results,simulate,Nreps;kwargs...)
end

"""
Extracts model and configuration from sampler object and performs
parameter estimation
* 's': sampler object
* `data': data for benchmarking
"""
function runSampler(s::AHMCNUTS,data;kwargs...)
    Turing.turnprogress(false)
    return sample(s.model(data...),s.config)
end

function runSampler(s::DNNUTS,data;kwargs...)
    Turing.turnprogress(false)
    return sample(s.model(data...),s.config)
end

function runSampler(s::CmdStanNUTS,data;kwargs...)
    rc, chns, cnames = stan(s.model,toDict(data),summary=false,s.dir)
    return chns
end

function runSampler(s::DHMCNUTS,data;kwargs...)
    return s.model(data...,s.Nsamples)
end

"""
update results on each iteration
* `s`: sampler object
* `t`: execution time
* `results`: DataFrame containing benchmark results
* `chain`: mcmc chain results
* `Nadapt`: number of adaption iterations to be removed from chain
"""
function updateResults!(s::AHMCNUTS,t,results,chain;kwargs...)
    newDF = DataFrame()
    chain=removeBurnin(chain;kwargs...)
    df = describe(chain)[1].df
    addColumns!(newDF,chain,df,:ess)
    addColumns!(newDF,chain,df,:r_hat)
    permutecols!(newDF,sort!(names(newDF)))#ensure correct order
    dfi=describe(chain,sections=[:internals])[1]
    newDF[:epsilon]=dfi[:lf_eps, :mean][1]
    newDF[:time] = t
    newDF[:sampler]=:AHMCNUTS
    addKW!(newDF;kwargs...)
    append!(results,newDF)
end

function updateResults!(s::CmdStanNUTS,t,results,chain;kwargs...)
    newDF = DataFrame()
    df = describe(chain)[1].df
    addColumns!(newDF,chain,df,:ess)
    addColumns!(newDF,chain,df,:r_hat)
    permutecols!(newDF,sort!(names(newDF)))#ensure correct order
    dfi=describe(chain,sections=[:internals])[1]
    newDF[:epsilon]=dfi[:stepsize__, :mean][1]
    newDF[:time] = t
    newDF[:sampler]=:CmdStanNUTS
    addKW!(newDF;kwargs...)
    append!(results,newDF)
end

function updateResults!(s::DNNUTS,t,results,chain;kwargs...)
    newDF = DataFrame()
    chain=removeBurnin(chain;kwargs...)
    df = describe(chain)[1].df
    addColumns!(newDF,chain,df,:ess)
    addColumns!(newDF,chain,df,:r_hat)
    permutecols!(newDF,sort!(names(newDF)))#ensure correct order
    newDF[:epsilon]=missing
    newDF[:time] = t
    newDF[:sampler]=:DNNUTS
    addKW!(newDF;kwargs...)
    allowmissing!(results,:epsilon)
    append!(results,newDF)
end

function updateResults!(s::DHMCNUTS,t,results,chain;kwargs...)
    newDF = DataFrame()
    chain=removeBurnin(chain;kwargs...)
    df = describe(chain)[1].df
    addColumns!(newDF,chain,df,:ess)
    addColumns!(newDF,chain,df,:r_hat)
    permutecols!(newDF,sort!(names(newDF)))#ensure correct order
    newDF[:epsilon]=missing
    newDF[:time] = t
    newDF[:sampler]=:DHMCNUTS
    addKW!(newDF;kwargs...)
    allowmissing!(results,:epsilon)
    append!(results,newDF)
end

"""
adds keyword arguments to DataFrame
* 'df': DataFrame containing benchmark results for single iteration
"""
function addKW!(df;kwargs...)
    for (k,v) in pairs(kwargs)
        setindex!(df,v,k)
    end
end

"""
Modifies MCMC sampler configuration outside of runSampler
* `s`: sampler object
"""
function modifyConfig!(s::AHMCNUTS;Nsamples,Nadapt,delta,kwargs...)
    s.config = Turing.NUTS(Nsamples,Nadapt,delta)
end

function modifyConfig!(s::CmdStanNUTS;Nsamples,Nadapt,delta,kwargs...)
    s.model.num_samples = Nsamples-Nadapt
    s.model.num_warmup = Nadapt
    s.model.method.adapt.delta = delta
end

function modifyConfig!(s::DNNUTS;Nsamples,kwargs...)
    s.config = DynamicNUTS(Nsamples)
end

function modifyConfig!(s::DHMCNUTS;Nsamples,kwargs...)
    s.Nsamples = Nsamples
end

function toDict(data)
    return Dict(string(k)=>v for (k,v) in pairs(data))
end

function removeBurnin(chn;Nadapt,kwargs...)
    return chn[(Nadapt+1):end,:,:]
end

"""
adds columns to newDF for each parameter.
* `newDF`: dataframe that collects results on an iteration
* `chn`: chain for given iteration
* `df`: df of chain results
* `col`: name of column

e.g. If col = :ess, and parameters are mu and sigma, the new columns
will be mu_ess and sigma_ess and will contain their respective ess values
"""
function addColumns!(newDF,chn,df,col)
    parms = sort!(chn.name_map.parameters)
    values = getindex(df,col)
    for (p,v) in zip(parms,values)
        colname = createName(p,col)
        setindex!(newDF,v,colname)
    end
end

function createName(p,col)
    if occursin(".",p)
        s = split(p,".")
        p = string(s[1],"[",s[2],"]")
    end
    return Symbol(string(p,"_",col))
end

export
  modifyConfig!,
  addColumns!,
  removeBurnin,
  toDict,
  addKW!,
  updateResults!,
  runSampler,
  benchmark!,
  MCMCSampler,
  AHMCNUTS,
  CmdStanNUTS,
  DHMCNUTS,
  DNNUTS,
  plotdensity

end # module
