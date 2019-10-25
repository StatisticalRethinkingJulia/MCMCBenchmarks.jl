using Distributions, Turing, Random, Parameters
import Base.rand
import Distributions: logpdf

struct LNR{T1,T2,T3} <: ContinuousUnivariateDistribution
    μ::T1
    σ::T2
    ϕ::T3
end

Broadcast.broadcastable(x::LNR) = Ref(x)

LNR(;μ, σ, ϕ) = LNR(μ, σ, ϕ)

function rand(dist::LNR)
    @unpack μ,σ,ϕ = dist
    x = @. rand(LogNormal(μ, σ)) + ϕ
    rt,resp = findmin(x)
    return resp,rt
end

rand(dist::LNR, N::Int) = [rand(dist) for i in 1:N]

function logpdf(d::T, r::Int, t::Float64) where {T<:LNR}
    @unpack μ,σ,ϕ = d
    LL = 0.0
    for (i,m) in enumerate(μ)
        if i == r
            LL += logpdf(LogNormal(m, σ), t-ϕ)
        else
            LL += log(1-cdf(LogNormal(m, σ), t-ϕ))
        end
    end
    return LL
end

logpdf(d::LNR, data::Tuple) = logpdf(d, data...)


@model model(data,Nr) = begin
    μ = Array{Real,1}(undef,Nr)
    μ ~ [Normal(0,3)]
    σ ~ Truncated(Cauchy(0, 1), 0, Inf)
    for i in 1:length(data)
        data[i] ~ LNR(μ, σ, 0.0)
    end
end

Random.seed!(343)
Nreps = 30
error_count = fill(0.0,Nreps)
Nr = 3

for i in 1:Nreps
    μ = rand(Normal(0 ,3), Nr)
    σ = rand(Uniform(.5, 2))
    dist = LNR(μ=μ, σ=σ, ϕ=0.0)
    data = rand(dist, 30)
    chain = sample(model(data, Nr), NUTS(1000, .8), 2000, discard_adapt = false)
    error_count[i] = sum(get(chain,:numerical_error)[1])
end

describe(error_count)
