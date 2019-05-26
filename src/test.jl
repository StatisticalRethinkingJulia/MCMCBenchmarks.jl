using Parameters
mutable struct Permutation{T1,T2}
    a::T1
    idx::Vector{Int64}
    N::T2
    start::Vector{Int64}
end

function Permutation(a)
    idx = fill(1,length(a))
    N = length.(a)
    start = [i[1] for i in a]
    return Permutation(a,idx,N,start)
end

Base.length(P::Permutation) = prod(P.N)

Base.eltype(::Type{Permutation{T}}) where {T} = Vector{eltype(T)}

Base.collect(P::Permutation) = [p for p in P]

function Base.iterate(p::Permutation,state=(p.start,0))
    @unpack a,idx,N=p
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
    newVal = [a[i][j] for (i,j) in enumerate(idx)]
    return (element,(newVal,count))
end


function fun(;kwargs...)
    K = kwargs.itr
    V = values(kwargs.data)
    P = Permutation(V)
    for p in P
        args = NamedTuple{K}(p)
        println(args)
    end
end

fun(;a=1:2,b=1)
