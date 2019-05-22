# chris_test_5a.jl

using MCMCBenchmarks

Random.seed!(38445)

ProjDir = @__DIR__
cd(ProjDir)

# Define user likelihood distribution

import Distributions: logpdf, pdf
mutable struct mydist{T1,T2} <: ContinuousUnivariateDistribution
    μ::T1
    σ::T2
end

function pdf(dist::mydist, x::Float64)
  @unpack μ,σ=dist
  pdf(Normal(μ,σ), x)
end

struct ChrisProblem5a{TY <: AbstractVector}
    "Observations."
    y::TY
end;

# Very constraint prior on μ. Flat σ.

function (problem::ChrisProblem5a)(θ)
    @unpack y = problem   # extract the data
    @unpack μ, σ = θ
    loglikelihood(Normal(μ, σ), y) + logpdf(Normal(0, 1), μ) + 
    logpdf(Truncated(Cauchy(0,1),0,Inf), σ)
end;

# Define problem with data and inits.
function dhmc_bm(data::Dict, Nsamples=2000)
  
  N = data["N"]
  obs = data["y"]
  p = ChrisProblem5a(obs);
  p((μ = 0.0, σ = 2.0))

  # Write a function to return properly dimensioned transformation.

  problem_transformation(p::ChrisProblem5a) =
      as((μ  = as(Real, -25, 25), σ = asℝ₊), )

  # Use Flux for the gradient.

  P = TransformedLogDensity(problem_transformation(p), p)
  #∇P = LogDensityRejectErrors(ADgradient(:ReverseDiff, P));
  ∇P = LogDensityRejectErrors(ADgradient(:ForwardDiff, P));

  # FSample from the posterior.

  chain, NUTS_tuned = NUTS_init_tune_mcmc(∇P, Nsamples, 
    report=ReportSilent());

  # Undo the transformation to obtain the posterior from the chain.

  posterior = TransformVariables.transform.(Ref(problem_transformation(p)), get_position.(chain));
  
  # Set varable names, this will be automated using θ

  parameter_names = ["μ", "σ"]

  # Create a3d

  a3d = Array{Float64, 3}(undef, Nsamples, 2, 1);
  for i in 1:Nsamples
    a3d[i, 1, 1] = values(posterior[i][1])
    a3d[i, 2, 1] = values(posterior[i][2])
  end

  chns = MCMCChains.Chains(a3d,
    parameter_names,
    Dict(
      :parameters => parameter_names,
    )
  );
  
  chns
end

BenchmarkTools.DEFAULT_PARAMETERS.samples = 50

Ns = [100, 500, 1000]

chns = Vector{MCMCChains.Chains}(undef, length(Ns))
t = Vector{BenchmarkTools.Trial}(undef, length(Ns))

for (i, N) in enumerate(Ns)
  data = Dict("y" => rand(Normal(0,1),N), "N" => N)
  t[i] = @benchmark dhmc_bm($data, $N)
  chns[i] = dhmc_bm(data, N)
end

t[1] |> display
println()
t[end] |> display

describe(chns[end])