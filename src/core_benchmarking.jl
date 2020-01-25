
"""
Abstract MCMC sampler type
"""
abstract type MCMCSampler end

"""
MCMC sampler struct for AdvancedHMC NUTS

* `model`: model function that accepts data
* `config`: sampler configution settings
* `name`: a unique identifer given to each sampler
"""
mutable struct AHMCNUTS{T1} <: MCMCSampler
    model::T1
    config::Turing.Inference.NUTS
    name::Symbol
    Nsamples::Int64
    autodiff::Symbol
end

AHMCNUTS(model, config)=AHMCNUTS(model, config, :AHMCNUTS, 0, :forward)

"""
MCMC sampler struct for CmdStan NUTS

* `model`: model configuration
* `dir`: probject directory
* `id`: a unique identifier for each instance of CmdStan in parallel applications
* `name`: a unique identifer given to each sampler
"""
mutable struct CmdStanNUTS{T1} <: MCMCSampler
    model::T1
    dir::String
    id::String
    name::Symbol
    autidiff::Symbol
end

CmdStanNUTS(model, dir) = CmdStanNUTS(model, dir, model.name, :CmdStanNUTS, :reverse)

"""
MCMC sampler struct for DynamicHMC NUTS

* `model`: model function that accepts data
* `config`: sampler configution settings
* `name`: a unique identifer given to each sampler
"""
mutable struct DHMCNUTS{T1,T2} <: MCMCSampler
    model::T1
    Nsamples::T2
    name::Symbol
    autodiff::Symbol
end

DHMCNUTS(model) = DHMCNUTS(model, 0, :DHMCNUTS, :forward)

"""
Primary function that performs mcmc benchmark repeatedly on a set of samplers
and records the results.
* 'sampler': tuple of sampler objects
* `results`: DataFrame containing benchmark results
* `csr̂`: cross sampler r̂
* `simulate`: data generating function
* `Nreps`: number of repetitions for a given set of simulation parameters. Default = 100
* `kwargs`: optional keyword arguments that are passed to modifyConfig!, updateResults! and
runSampler, providing flexibility in benchmark simulations.
"""
function benchmark!(samplers, results, csr̂, simulate, Nreps, chains; kwargs...)
    for rep in 1:Nreps
      data = simulate(;kwargs...)
      schains = Chains[]
      for s in samplers
          modifyConfig!(s; kwargs...)
          println("\nSampler: $(typeof(s))")
          println("Simulation: $simulate")
          println("Repetition: $rep of $Nreps\n")
          foreach(x->println(x),kwargs)
          performance = @timed runSampler(s, data; kwargs...)
          push!(schains, performance[1])
          allowmissing!(results)
          results = updateResults!(s, performance, results; kwargs...)
          savechain!(s ,chains, performance; kwargs...)
      end
      csr̂=cross_samplerRhat!(schains, csr̂; kwargs...)
    end
    return results,csr̂
end

function benchmark!(sampler::T, results, csr̂, simulate, Nreps, chains; kwargs...) where {T<:MCMCSampler}
    return benchmark!((sampler, ), results, simulate, Nreps, chains; kwargs...)
end

"""
Runs the benchmarking procedure and returns the results

* `samplers`: a tuple of samplers or a single sampler object
* `simulate`: model simulation function with keyword Nd
* `Nreps`: number of times the benchmark is repeated for each factor combination
"""
 function benchmark(samplers, simulate, Nreps, chains=(); kwargs...)
     results = DataFrame()
     csr̂ = DataFrame()
     for p in Permutation(kwargs)
         results,csr̂=benchmark!(samplers, results, csr̂, simulate, Nreps, chains; p...)
     end
     return [results csr̂]
 end

 """
 Runs the benchmarking procedure defined in benchmark in parallel and returns the results


 * `samplers`: a tuple of samplers or a single sampler object
 * `simulate`: model simulation function with keyword Nd
 * `Nreps`: number of times the benchmark is repeated for each factor combination
 """
 function pbenchmark(samplers, simulate, Nreps; kwargs...)
     compile(samplers, simulate; kwargs...)
     pfun(rep) = benchmark(samplers, simulate, rep, chains; kwargs...)
     reps = setreps(Nreps)
     presults = pmap(rep->pfun(rep), reps)
     return vcat(presults..., cols=:union)
 end

"""
Extracts model and configuration from sampler object and performs
parameter estimation
* `s`: sampler object
* `data`: data for benchmarking
* `Nchains`: number of chains ran serially. Default =  1
"""
function runSampler(s::AHMCNUTS, data; Nchains=1, kwargs...)
    f() = sample(s.model(data...), s.config, s.Nsamples; discard_adapt=false,
        progress=false)
    return reduce(chainscat, map(x->f(), 1:Nchains))
end

function runSampler(s::CmdStanNUTS, data; Nchains=1, kwargs...)
    f() = stan(s.model, toDict(data), summary=false, s.dir)[2]
    return reduce(chainscat, map(x->f(), 1:Nchains))
end

function runSampler(s::DHMCNUTS, data; Nchains=1, kwargs...)
    f() = s.model(data..., s.Nsamples, s.autodiff)
    return reduce(chainscat, map(x->f(), 1:Nchains))
end

"""
Update the results DataFrame on each iteration
* `s`: MCMC sampler object
* `performance`: includes MCMC Chain, execution time, and memory measurements
* `results`: DataFrame containing benchmark results
"""
function updateResults!(s::AHMCNUTS, performance, results; kwargs...)
    chain = performance[1]
    newDF = DataFrame()
    chain=removeBurnin(chain; kwargs...)
    df = MCMCChains.describe(chain)[1].df
    addChainSummary!(newDF, chain,df,:ess)
    addChainSummary!(newDF, chain,df,:r_hat)
    addESStime!(newDF, chain, df, performance)
    addHPD!(newDF, chain)
    addMeans!(newDF, df)
    select!(newDF, sort!(names(newDF)))#ensure correct order
    dfi=MCMCChains.describe(chain, sections=[:internals])[1]
    newDF[!,:epsilon] = [dfi[:step_size,:mean][1]]
    newDF[!,:tree_depth] = [dfi[:tree_depth, :mean][1]]
    addPerformance!(newDF,performance)
    newDF[!,:sampler] = [s.name]
    addKW!(newDF; kwargs...)
    return vcat(results, newDF, cols=:union)
end

function updateResults!(s::CmdStanNUTS, performance, results; kwargs...)
    chain = performance[1]
    newDF = DataFrame()
    chain=removeBurnin(chain; kwargs...)
    df = MCMCChains.describe(chain)[1].df
    addChainSummary!(newDF, chain, df, :ess)
    addChainSummary!(newDF,chain,df,:r_hat)
    addESStime!(newDF, chain, df, performance)
    addHPD!(newDF, chain)
    addMeans!(newDF, df)
    select!(newDF, sort!(names(newDF)))#ensure correct order
    dfi=MCMCChains.describe(chain, sections=[:internals])[1]
    newDF[!,:epsilon] = [dfi[:stepsize__, :mean][1]]
    newDF[!,:tree_depth] = [dfi[:treedepth__, :mean][1]]
    addPerformance!(newDF, performance)
    newDF[!,:sampler] = [s.name]
    addKW!(newDF; kwargs...)
    return vcat(results, newDF, cols=:union)
end

function updateResults!(s::DHMCNUTS, performance, results; kwargs...)
    chain = performance[1]
    newDF = DataFrame()
    chain = removeBurnin(chain; kwargs...)
    df = MCMCChains.describe(chain)[1].df
    addChainSummary!(newDF, chain, df, :ess)
    addChainSummary!(newDF, chain, df, :r_hat)
    addESStime!(newDF, chain, df, performance)
    addHPD!(newDF, chain)
    addMeans!(newDF, df)
    select!(newDF, sort!(names(newDF)))#ensure correct order
    dfi=MCMCChains.describe(chain, sections=[:internals])[1]
    newDF[!,:epsilon] = [dfi[:lf_eps, :mean][1]]
    newDF[!,:tree_depth] = [dfi[:tree_depth, :mean][1]]
    addPerformance!(newDF,performance)
    newDF[!,:sampler] = [s.name]
    addKW!(newDF; kwargs...)
    return vcat(results, newDF, cols=:union)
end

"""
Modifies MCMC sampler configuration, including number of samples, target
acceptance rate and others depending on the specific sampler.
* `s`: sampler object
* `Nsamples`: total number of MCMC samples
* `Nadapt`: number of adaption samples during warm up
* `delta`: target acceptance rate.
"""
function modifyConfig!(s::AHMCNUTS; Nsamples, Nadapt, delta, autodiff=:forward, kwargs...)
    s.config = Turing.NUTS(Nadapt, delta)
    s.Nsamples = Nsamples
    println("Nsamples" , Nsamples)
    s.autodiff = autodiff == :reverse ? Turing.setadbackend(:reverse_diff) : Turing.setadbackend(:forward_diff)
end

function modifyConfig!(s::CmdStanNUTS; Nsamples, Nadapt, delta, kwargs...)
    s.model.num_samples = Nsamples-Nadapt
    s.model.num_warmup = Nadapt
    s.model.method.adapt.delta = delta
    s.model.method.num_samples = Nsamples-Nadapt
    s.model.method.num_warmup = Nadapt
    id = myid()
    if id != 1
        s.model.name = string(s.id,id)
    end
end

function modifyConfig!(s::DHMCNUTS; Nsamples, autodiff=:forward, kwargs...)
    s.Nsamples = Nsamples
    s.autodiff = autodiff == :reverse ? :ReverseDiff : :ForwardDiff
end
