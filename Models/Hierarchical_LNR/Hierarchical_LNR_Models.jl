using Distributions, Parameters
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


@model lnrModel(data, idx, N, Nsub, ::Type{T}=Vector{Float64},
    ::Type{T1}=Array{Float64,2}) where {T,T1}  = begin
    Nr = 3
    mu_g = T(undef,Nr)
    sigma_g ~ Truncated(Cauchy(0, 1), 0.0, Inf)
    mu_g ~ [Normal(0,3)]
    mu = T1(undef,Nsub,Nr)
    for s in 1:Nsub
        for i in 1:Nr
            mu[s,i] ~ Normal(mu_g[i], sigma_g)
        end
    end
    sigma ~ Truncated(Cauchy(0, 1), 0.0, Inf)
    for i in 1:N
        data[i] ~ LNR(mu[idx[i],:], sigma, 0.0)
    end
end

function simulateLNR(; Nd=1, Nsub, mu_g = [-1.0,-2.0,-.5], sigma_g = 1,
     sigma = 1, kwargs...)
    N = Nd * Nsub
    choice = fill(0, N)
    rt = fill(0.0, N)
    idx = similar(choice)
    i = 0
    for s in 1:Nsub
        mu = @. rand(Normal(mu_g, sigma_g))
        dist = LNR(μ=mu, σ=sigma, ϕ=0.0)
        for _ in 1:Nd
            i += 1
            idx[i] = s
            choice[i],rt[i] = rand(dist)
        end
    end
    return (choice=choice, rt=rt, idx=idx, N=N, Nsub=Nsub)
 end

function AHMClnr(choice, rt, idx, N, Nsub)
    data=[(c,r) for (c,r) in zip(choice,rt)]

    return lnrModel(data, idx, N, Nsub)
end

AHMCconfig = Turing.NUTS(1000,.85)

CmdStanLNR = "
functions{

    real LNR_LL(row_vector mus,real sigma,real ter,real v,int c){
      real LL;
      LL = 0;
      for(i in 1:num_elements(mus)){
        if(i == c){
          LL += lognormal_lpdf(v-ter|mus[i],sigma);
      }else{
        LL += log(1-lognormal_cdf(v-ter,mus[i],sigma));
      }
    }
      return LL;
    }

    }

data{
     int N;
     int Nr;
     int Nsub;
     vector[N] rt;
     vector[N] choice;
}

parameters {
     vector[Nr] mu_g;
     matrix[Nsub,Nr] mu;
     real<lower=0> sigma_g;
     real<lower=0> sigma;
}

model {
     mu_g ~ normal(0, 3);
     sigma_g ~ cauchy(0,1);
     for(s in 1:Nsub){
         for(i in 1:Nr){
            mu[s,i] ~ normal(mu_g[i], sigma_g);
        }
     }
     sigma ~ cauchy(0,1);
     for(i in 1:N){
         target += LNR_LL(mu[idx[i],:], sigma, 0.0, rt[i], choice[i]);
      }
}
"

CmdStanConfig = Stanmodel(name="CmdStanLNR", model=CmdStanLNR, nchains=1,
   Sample(num_samples=1000, num_warmup=1000, adapt=CmdStan.Adapt(delta=0.8),
   save_warmup=true))

   struct LNRProb{T}
      data::T
      N::Int
      Nc::Int
  end

  function (problem::LNRProb)(θ)
      @unpack data=problem
      @unpack v,A,k,tau=θ
      d=LBA(ν=v, A=A, k=k, τ=tau)
      minRT = minimum(x->x[2], data)

      logpdf(d,data)+sum(logpdf.(TruncatedNormal(0, 3, 0, Inf), v)) +
      logpdf(TruncatedNormal(.8, .4, 0, Inf),A)+logpdf(TruncatedNormal(.2, .3 ,0 ,Inf), k)+
      logpdf(TruncatedNormal(.4, .1, 0, minRT), tau)
  end

function sampleDHMC(choice, rt, N, Nc, nsamples)
    data = [(c, r) for (c, r) in zip(choice, rt)]
    return sampleDHMC(data, N, Nc, nsamples)
end

# Define problem with data and inits.
function sampleDHMC(data, N, Nc, nsamples, autodiff)
    p = LBAProb(data, N, Nc)
    p((v=fill(.5, Nc), A=.8, k=.2, tau=.4))
    # Write a function to return properly dimensioned transformation.
    trans = as((v=as(Array, asℝ₊, Nc),A=asℝ₊, k=asℝ₊, tau=asℝ₊))
    # Use Flux for the gradient.
    P = TransformedLogDensity(trans, p)
    ∇P = ADgradient(autodiff, P)
    # FSample from the posterior.
    n = dimension(trans)
    results = mcmc_with_warmup(Random.GLOBAL_RNG, ∇P, nsamples;
        q = zeros(n), p = ones(n),reporter = NoProgressReport())
    # Undo the transformation to obtain the posterior from the chain.
    posterior = transform.(trans, results.chain)
    chns = nptochain(results, posterior)
    return chns
end

function simulateLBA(;Nd, v=[1.0,1.5,2.0], A=.8, k=.2, tau=.4, kwargs...)
    return (rand(LBA(ν=v, A=A, k=k, τ=tau), Nd)..., N=Nd, Nc=length(v))
end
