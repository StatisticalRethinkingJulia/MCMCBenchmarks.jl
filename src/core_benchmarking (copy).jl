"""
Computes r̂ across a set of chains from different samplers.
* `schains`: a vector of chains from different samplers
* `csr̂`: A DataFrame containing cross sampler r̂. This is concatonated to the
results DataFrame
"""
function cross_samplerRhat!(schains,csr̂;kwargs...)
    schains = Chains.(schains)
    schains = standardizeNames.(schains)
    chains = reduce(chainscat,schains)
    chains = removeBurnin(chains;kwargs...)
    df = MCMCChains.describe(chains)[1].df
    sort!(df)
    parms = sort!(chains.name_map.parameters)
    values = df[!,:r_hat]
    N = length(schains)
    newDF = DataFrame()
    for (p,v) in zip(parms,values)
        colname = createName(p,:sampler_rhat)
        V = fill(v,N)
        newDF[!,colname] = V
    end
    return vcat(csr̂,newDF,cols=:union)
end

"""
Adds keyword arguments to the results DataFrame
* `df`: DataFrame containing benchmark results for single iteration
* `kwargs`: keyword arguments
"""
function addKW!(df;kwargs...)
    for (k,v) in pairs(kwargs)
        df[!,k] = [v]
    end
end

"""
Adds performance metrics to benchmark results, which include runtime,
memory allocations in MB, garbage collection time, percent of time spent in garbage collection,
and the number of memory allocations
* `df`: the dataframe to which performance metrics are added
* `p`: a collection of performance metrics including run time,
memory allocations and garbage collection time
"""
function addPerformance!(df,p)
    df[!,:time] = [p[2]]
    df[!,:megabytes] = [p[3]/1e6]
    df[!,:gctime] = [p[4]]
    df[!,:gcpercent] = [p[4]/p[2]]
    df[!,:allocations] = [p[5].poolalloc + p[5].malloc]
end

function toDict(data)
    return Dict(string(k)=>v for (k,v) in pairs(data))
end

function removeBurnin(chn;Nadapt,kwargs...)
    return chn[(Nadapt+1):end,:,:]
end

function savechain!(s,chains,performance;savechain=false,kwargs...)
    if savechain
        k = gettype(s)
        push!(chains[k],performance[1])
    end
end

"""
Adds chain summary (e.g. rhat,ess) to newDF for each parameter.
* `newDF`: dataframe that collects results on an iteration
* `chn`: chain for given iteration
* `df`: df of chain results
* `col`: name of column

e.g. If col = :ess, and parameters are mu and sigma, the new columns
will be mu_ess and sigma_ess and will contain their respective ess values
"""
function addChainSummary!(newDF,chn,df,col)
    parms = sort!(chn.name_map.parameters)
    values = df[!,col]
    for (p,v) in zip(parms,values)
        colname = createName(p,col)
        newDF[!,colname] = [v]
    end
end

"""
Effective Sample Size per second
* `newDF`: new DataFrame to be added to results DataFrame
* `chain`: MCMC chain
* `df`: DataFrame containing posterior summaries
* `performance`: a collection of performance metrics including run time,
memory allocations and garbage collection time
"""
function addESStime!(newDF,chn,df,performance)
    parms = sort!(chn.name_map.parameters)
    values = df[!,:ess]/performance[2]
    for (p,v) in zip(parms,values)
        colname = createName(p,"ess_ps")
        newDF[!,colname] = [v]
    end
end

"""
Add highest probability density interval for each parameter
* `newDF`: new DataFrame to be added to results DataFrame
* `chain`: MCMC chain
"""
function addHPD!(newDF,chain)
    h = hpd(chain)
    for r in eachrow(h.df)
        p,lb,ub = r
        colname = createName(string(p),"hdp_lb")
        newDF[!,colname] = [lb]
        colname = createName(string(p),"hdp_ub")
        newDF[!,colname] = [ub]
    end
end

"""
Add mean for each parameter
* `newDF`: new DataFrame to be added to results DataFrame
* `df`: DataFrame containing posterior summaries
"""
function addMeans!(newDF,df)
    for r in eachrow(df)
        p=r[:parameters]
        v = r[:mean]
        colname = createName(string(p),"mean")
        newDF[!,colname] = [v]
    end
end

function standardizeNames(chain)
    nms = names(chain)
    newNames = standardizeName.(nms)
    newChain = Chains(chain.value.data,newNames)
    return newChain
end

function standardizeName(p)
    if occursin(".",p)
        s = split(p,".")
        p = string(s[1],"[",s[2],"]")
    end
    return p
end

function createName(p,col)
    p = standardizeName(p)
    return Symbol(string(p,"_",col))
end

function gettype(s)
    return Symbol(typeof(s).name)
end

initChains(s::T) where {T<:MCMCSampler} = initChains((s,))

"""
Initializes NamedTuple of chains
* s: sampler object
"""
function initChains(s)
    names = gettype.(s)
    v = map(x->Chains[],1:length(s))
    return NamedTuple{names}(v)
end

function Chains(chain::Chains)
    parms = String.(chain.name_map.parameters)
    sort!(parms)
    v=chain[:,parms,:].value.data
    return Chains(v,parms)
end
