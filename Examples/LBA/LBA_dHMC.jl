using Distributions,Parameters,DynamicHMC,LogDensityProblems,TransformVariables
using Random
import Distributions: pdf,logpdf,rand
export LBA,pdf,logpdf,rand

#  See discussions at https://discourse.julialang.org/t/dynamichmc-reached-maximum-number-of-iterations/24721

############################################################################################
#                                    Model functions
############################################################################################

mutable struct LBA{T1,T2,T3,T4} <: ContinuousUnivariateDistribution
    ν::T1
    A::T2
    k::T3
    τ::T4
    σ::Float64
end

Base.broadcastable(x::LBA)=Ref(x)

LBA(;τ,A,k,ν,σ=1.0) = LBA(ν,A,k,τ,σ)

function selectWinner(dt)
    if any(x->x >0,dt)
        mi,mv = 0,Inf
        for (i,t) in enumerate(dt)
            if (t > 0) && (t < mv)
                mi = i
                mv = t
            end
        end
    else
        return 1,-1.0
    end
    return mi,mv
end

function sampleDriftRates(ν,σ)
    noPositive=true
    v = similar(ν)
    while noPositive
        v = [rand(Normal(d,σ)) for d in ν]
        any(x->x>0,v) ? noPositive=false : nothing
    end
    return v
end

function rand(d::LBA)
    @unpack τ,A,k,ν,σ = d
    b=A+k
    N = length(ν)
    v = sampleDriftRates(ν,σ)
    a = rand(Uniform(0,A),N)
    dt = @. (b-a)/v
    choice,mn = selectWinner(dt)
    rt = τ .+ mn
    return choice,rt
end

function rand(d::LBA,N::Int)
    choice = fill(0,N)
    rt = fill(0.0,N)
    for i in 1:N
        choice[i],rt[i]=rand(d)
    end
    return (choice=choice,rt=rt)
end

logpdf(d::LBA,choice,rt) = log(pdf(d,choice,rt))

function logpdf(d::LBA,data::T) where {T<:NamedTuple}
    return sum(logpdf.(d,data...))
end

function logpdf(dist::LBA,data::Array{<:Tuple,1})
    LL = 0.0
    for d in data
        LL += logpdf(dist,d...)
    end
    return LL
end

function pdf(d::LBA,c,rt)
    @unpack τ,A,k,ν,σ = d
    b=A+k; den = 1.0
    rt < τ ? (return 1e-10) : nothing
    for (i,v) in enumerate(ν)
        if c == i
            den *= dens(d,v,rt)
        else
            den *= (1-cummulative(d,v,rt))
        end
    end
    pneg = pnegative(d)
    den = den/(1-pneg)
    den = max(den,1e-10)
    isnan(den) ? (return 0.0) : (return den)
end

function dens(d::LBA,v,rt)
    @unpack τ,A,k,ν,σ = d
    dt = rt-τ; b=A+k
    n1 = (b-A-dt*v)/(dt*σ)
    n2 = (b-dt*v)/(dt*σ)
    dens = (1/A)*(-v*cdf(Normal(0,1),n1) + σ*pdf(Normal(0,1),n1) +
        v*cdf(Normal(0,1),n2) - σ*pdf(Normal(0,1),n2))
    return dens
end

function cummulative(d::LBA,v,rt)
    @unpack τ,A,k,ν,σ = d
    dt = rt-τ; b=A+k
    n1 = (b-A-dt*v)/(dt*σ)
    n2 = (b-dt*v)/(dt*σ)
    cm = 1 + ((b-A-dt*v)/A)*cdf(Normal(0,1),n1) -
        ((b-dt*v)/A)*cdf(Normal(0,1),n2) + ((dt*σ)/A)*pdf(Normal(0,1),n1) -
        ((dt*σ)/A)*pdf(Normal(0,1),n2)
    return cm
end

function pnegative(d::LBA)
    @unpack ν,σ=d
    p=1.0
    for v in ν
        p*= cdf(Normal(0,1),-v/σ)
    end
    return p
end

############################################################################################
#                                            DynamicHMC
############################################################################################
struct LBAProb{T}
   data::T
   N::Int
   Nc::Int
end

function (problem::LBAProb)(θ)
    @unpack data=problem
    @unpack v,A,k,tau=θ
    d=LBA(ν=v,A=A,k=k,τ=tau)
    logpdf(d,data)+sum(logpdf.(TruncatedNormal(0,3,0,Inf),v)) +
    logpdf(TruncatedNormal(.8,.4,0,Inf),A)+logpdf(TruncatedNormal(.2,.3,0,Inf),k)+
    logpdf(TruncatedNormal(.4,.1,0,Inf),tau)
end

# Define problem with data and inits.
function sampleDHMC(data,N,Nc,nsamples)
  p = LBAProb(data,N,Nc)
  p((v=fill(.5,Nc),A=.8,k=.2,tau=.4))
  # Write a function to return properly dimensioned transformation.
  problem_transformation(p::LBAProb) =
  as((v=as(Array,asℝ₊,Nc),A=asℝ₊,k=asℝ₊,tau=asℝ₊))
  # Use Flux for the gradient.
  P = TransformedLogDensity(problem_transformation(p), p)
  #∇P = LogDensityRejectErrors(ADgradient(:ForwardDiff, P))
  ∇P = ADgradient(:ForwardDiff, P)
  # FSample from the posterior.
  chain, NUTS_tuned = NUTS_init_tune_mcmc(∇P,nsamples)
  # Undo the transformation to obtain the posterior from the chain.
  posterior = TransformVariables.transform.(Ref(problem_transformation(p)), get_position.(chain));
  return (posterior, chain, NUTS_tuned)
end
############################################################################################
#                                         Run Code
############################################################################################
#Random.seed!(5015)
dist = LBA(ν=[1.0,1.5,2.0],A=.8,k=.2,τ=.4)
N = 10
Nc = 3
data = rand(dist,N)
posterior , chain, NUTS_tuned= sampleDHMC(data,N,Nc,2000)

# Effective sample sizes (of untransformed draws)

@show ess = mapslices(effective_sample_size,
                get_position_matrix(chain); dims = 1)
println()

# NUTS-specific statistics

@show NUTS_statistics(chain)
println()

@show NUTS_tuned
