import Distributions: logpdf,pdf

struct SDT{T1,T2} <: ContinuousUnivariateDistribution
    d::T1
    c::T2
end

logpdf(d::SDT,data::Vector{Int64}) = logpdf(d,data...)

logpdf(d::SDT,data::Tuple{Vararg{Int64}}) = logpdf(d,data...)

function logpdf(d::SDT,hits,fas,Nd)
    @unpack d,c=d
    θhit=cdf(Normal(0,1),d/2-c)
    θfa=cdf(Normal(0,1),-d/2-c)
    loghits = logpdf(Binomial(Nd,θhit),hits)
    logfas = logpdf(Binomial(Nd,θfa),fas)
    return loghits+logfas
end

pdf(d::SDT,data::Vector{Int64}) = exp(logpdf(d,data...))

function benchmark(samplers,simulate,Nd,Nreps=100)
    results = DataFrame()
    for nd in Nd
        benchmark!(samplers,results,simulate,Nreps;Nd=nd,Nsamples=2000,Nadapt=1000,delta=.8)
    end
    return results
end
