import Distributions: logpdf, DiscreteUnivariateDistribution

"""
Numerically stable Poisson log likelihood function. Accepts log of rate parameter.
"""
struct LogPoisson{T<:Real} <: DiscreteUnivariateDistribution
    logλ::T
end

function logpdf(lp::LogPoisson, k::Int)
    return k * lp.logλ - exp(lp.logλ) - lgamma(k + 1)
end

@model AHMCpoisson(y, x, idx, N, Ns) = begin
  a0 ~ Normal(0, 10)
  a1 ~ Normal(0, 1)
  a0_sig ~ Truncated(Cauchy(0, 1), 0, Inf)
  a0s ~ MvNormal(zeros(Ns), a0_sig)
  for i ∈ 1:N
    λ = a0 + a0s[idx[i]] + a1 * x[i]
    y[i] ~ LogPoisson(λ)
  end
end

AHMCconfig = Turing.NUTS(1000, .80)

function simulatePoisson(; Nd=1, Ns=10, a0=1.0, a1=.5, a0_sig=.3, kwargs...)
  N = Nd * Ns
  y = fill(0, N)
  x = fill(0.0, N)
  idx = similar(y)
  i = 0
  for s in 1:Ns
    a0s = rand(Normal(0, a0_sig))
    logpop = rand(Normal(9, 1.5))
    λ = exp(a0 + a0s + a1 * logpop)
    for nd in 1:Nd
      i += 1
      x[i] = logpop
      idx[i] = s
      y[i] = rand(Poisson(λ))
    end
  end
  return (y=y, x=x, idx=idx, N=N, Ns=Ns)
 end

CmdStanPoisson = "
data {
  int N;
  int y[N];
  int Ns;
  int idx[N];
  real x[N];
}
parameters {
  real a0;
  vector[Ns] a0s;
  real a1;
  real<lower=0> a0_sig;
}
model {
  vector[N] mu;
  a0 ~ normal(0, 10);
  a1 ~ normal(0, 1);
  a0_sig ~ cauchy(0, 1);
  a0s ~ normal(0, a0_sig);
  for(i in 1:N) mu[i] = exp(a0 + a0s[idx[i]] + a1 * x[i]);
  y ~ poisson(mu);
}
"

CmdStanConfig = Stanmodel(
  name="CmdStanPoisson", model=CmdStanPoisson, nchains=1,
  Sample(num_samples=1000, num_warmup=1000, adapt=CmdStan.Adapt(delta=0.8), save_warmup=true)
)

struct PoissonProb
  y::Array{Int64,1}
  x::Array{Float64,1}
  idx::Array{Int64,1}
  N::Int64
  Ns::Int64
end

function (problem::PoissonProb)(θ)
  @unpack y, x, idx, N, Ns = problem   # extract the data
  @unpack a0, a1, a0s, a0_sig = θ
  LL = 0.0
  LL += logpdf(Truncated(Cauchy(0, 1), 0, Inf), a0_sig)
  LL += sum(logpdf(MvNormal(zeros(Ns), a0_sig), a0s))
  LL += logpdf.(Normal(0, 10), a0)
  LL += logpdf.(Normal(0, 1), a1)
  for i in 1:N
    λ = a0 + a0s[idx[i]] + a1 * x[i]
    LL += logpdf(LogPoisson(λ), y[i])
  end
  return LL
end

# Define problem with data and inits.
function sampleDHMC(y, x, idx, N, Ns, nsamples, autodiff)
  p = PoissonProb(y, x, idx, N, Ns)
  p((a0=0.0, a1=0.0, a0s=fill(0.0, Ns), a0_sig=.3))
  # Write a function to return properly dimensioned transformation.
  trans = as((a0=asℝ, a1=asℝ, a0s=as(Array, Ns), a0_sig=asℝ₊))
  P = TransformedLogDensity(trans, p)
  ∇P = ADgradient(autodiff, P)
  # Sample from the posterior.
  results = mcmc_with_warmup(Random.GLOBAL_RNG, ∇P, nsamples; reporter = NoProgressReport())
  # Undo the transformation to obtain the posterior from the chain.
  posterior = transform.(trans, results.chain)
  chns = nptochain(results, posterior)
  return chns
end
