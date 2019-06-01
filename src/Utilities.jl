using Base.Sys
"""
Convert DynamcHMC samples to a chain
* `posterior`: an array of NamedTuple consisting of mcmcm samples
"""
function nptochain(posterior,tune)
    Np = length(vcat(posterior[1]...))+1 #include lf_eps
    Ns = length(posterior)
    a3d = Array{Float64,3}(undef,Ns,Np,1)
    ϵ=tune.ϵ
    for (i,post) in enumerate(posterior)
        temp = Float64[]
        for p in post
            push!(temp,values(p)...)
        end
        push!(temp,ϵ)
        a3d[i,:,1] = temp'
    end
    parameter_names = getnames(posterior)
    push!(parameter_names,"lf_eps")
    chns = MCMCChains.Chains(a3d,parameter_names,
        Dict(:internals => ["lf_eps"]))
    return chns
end

function getnames(post)
    nt = post[1]
    Np =length(vcat(nt...))
    parm_names = fill("",Np)
    cnt = 0
    for (k,v) in pairs(nt)
        N = length(v)
        if N > 1
            for i in 1:N
                cnt += 1
                parm_names[cnt] = string(k,"[",i,"]")
            end
        else
            cnt+=1
            parm_names[cnt] = string(k)
        end
    end
    return parm_names
end

function setprocs(n)
    np = nprocs()-1
    m = max(n-np,0)
    addprocs(m)
end

function save(results,ProjDir)
    str = string(round(now(),Dates.Minute))
    str = replace(str,"-"=>"_")
    str = replace(str,":"=>"_")
    dir = string(ProjDir,"/results")
    !isdir(dir) ? mkdir(dir) : nothing
    newdir = dir*"/"*str
    mkdir(newdir)
    CSV.write(newdir*"/results.csv",results)
    metadata = getMetadata()
    CSV.write(newdir*"/metadata.csv",metadata)
end

function getMetadata()
    path = getpath()
    dict = TOML.parsefile(path)
    df = DataFrame()
    pkgs = [:CmdStan,:DynamicHMC,
        :Turing,:AdvancedHMC]
    map(p->df[p]=dict[string(p)][1]["version"],pkgs)
    df[:julia] = VERSION
    df[:os] = MACHINE
    cpu = cpu_info()
    df[:cpu] = cpu[1].model
    return df
end

function getpath()
    userdir = expanduser("~")
    str = split(string(VERSION),".")[1:end-1]
    str1 = [str[s]*"." for s in 1:length(str)-1]
    push!(str1,str[end])
    version = string(str1...)
    path = joinpath(userdir, string(".julia/environments/v",version,"/Manifest.toml"))
    return path
end

"""
Iterates over all permutations of factors in the benchmark simulation.
"""
mutable struct Permutation{T1,T2,T3,T4}
    a::T1
    names::T2
    idx::Vector{Int64}
    N::T3
    start::T4
end

function Permutation(kwargs)
    names = kwargs.itr
    a = values(kwargs.data)
    idx = fill(1,length(a))
    N = length.(a)
    v = [i[1] for i in a]
    start = NamedTuple{names}(v)
    return Permutation(a,names,idx,N,start)
end

Base.length(P::Permutation) = prod(P.N)

Base.eltype(::Type{Permutation{T}}) where {T} = Vector{eltype(T)}

Base.collect(P::Permutation) = [p for p in P]

function Base.iterate(p::Permutation,state=(p.start,0))
    @unpack a,idx,names,N=p
    element,count = state
    count == length(p) ? (return nothing) : nothing
    K = length(p.idx)
    for j in K:-1:1
        if idx[j] == N[j]
            idx[j] = 1
        else
            idx[j] += 1
            break
        end
    end
    count += 1
    v = [a[i][j] for (i,j) in enumerate(idx)]
    newVal = NamedTuple{names}(v)
    return (element,(newVal,count))
end

function initStan(s)
    base = string(s.dir,"/tmp/",s.model.name)
    for p in procs()
        stream = open(base*".stan","r")
        str = read(stream,String)
        close(stream)
        stream = open(string(base,p,".stan"),"w")
        write(stream,str)
        close(stream)
    end
end

function compileStanModel(s,fun)
    data = fun(;Nd=1)
    pmap(x->compile(s,data),procs())
end

function compile(s,data)
    modifyConfig!(s;Nsamples=10,Nadapt=10,delta=.8)
    runSampler(s,data)
    return
end

function setreps(Nreps)
    p = nprocs()-1
    v = Int(floor(Nreps/p))
    reps = fill(v,p)
    r = mod(Nreps,p)
    reps[1:r] .+= 1
    return reps
end
