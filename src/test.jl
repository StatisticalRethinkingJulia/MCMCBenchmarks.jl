using Parameters,Distributions
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

function Permutation(kwargs::T) where {T<:NamedTuple}
    names = keys(kwargs)
    a = values(kwargs)
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


function benchmark(samplers,simulate,Nd,Nreps=100;kwargs...)
    results = DataFrame()
    for p in Permutation(kwargs)
        benchmark!(samplers,results,simulate,Nreps;Nd=nd,Nsamples=Nsamples,Nadapt=Nadapt,delta=delta)
    end
    return results
end

@code_warntype fun(;a=1:2,b=1,c=[Normal(0,1),Normal(0,2)])
