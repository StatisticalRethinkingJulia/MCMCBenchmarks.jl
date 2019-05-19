# # Linear regression

# We estimate simple linear regression model with a half-T prior.
# First, we load the packages we use.

using TransformVariables, LogDensityProblems, DynamicHMC, MCMCDiagnostics,
    Parameters, Statistics, Distributions, ForwardDiff
using DynamicHMCModels, MCMCChains

# Then define a structure to hold the data: observables, covariates, and the degrees of freedom for the prior.

"""
Linear regression model ``y ∼ Xβ + ϵ``, where ``ϵ ∼ N(0, σ²)`` IID.
Flat prior for `β`, half-T for `σ`.
"""
struct LinearRegressionProblem{TY <: AbstractVector, TX <: AbstractMatrix,
                               Tν <: Real}
    "Observations."
    y::TY
    "Covariates"
    X::TX
    "Degrees of freedom for prior."
    ν::Tν
end

# Then make the type callable with the parameters *as a single argument*.

function (problem::LinearRegressionProblem)(θ)
    @unpack y, X, ν = problem   # extract the data
    @unpack β, σ = θ            # works on the named tuple too
    loglikelihood(Normal(0, σ), y .- X*β) + logpdf(TDist(ν), σ)
end

# We should test this, also, this would be a good place to benchmark and
# optimize more complicated problems.

Nobs = 10
Nparms = 2
Ncoef = 3
Nchains = 4
Nsamples = 1000

X = hcat(ones(Nobs), randn(Nobs, 2));
β = [1.0, 2.0, -1.0]
β = vcat([1.0], sample(-5:5, Nparms, replace=true))
σ = 0.5
y = X*β .+ randn(Nobs) .* σ;
p = LinearRegressionProblem(y, X, 1.0);
p((β = β, σ = σ))

# For this problem, we write a function to return the transformation (as it varies with the number of covariates).

problem_transformation(p::LinearRegressionProblem) =
    as((β = as(Array, size(p.X, 2)), σ = asℝ₊))

# Wrap the problem with a transformation, then use Flux for the gradient.

P = TransformedLogDensity(problem_transformation(p), p)
#∇P = LogDensityRejectErrors(ADgradient(:ForwardDiff, P));
∇P = ADgradient(:ForwardDiff, P);

# Finally, we sample from the posterior. `chain` holds the chain (positions and
# diagnostic information), while the second returned value is the tuned sampler
# which would allow continuation of sampling.

chain, NUTS_tuned = NUTS_init_tune_mcmc(∇P, Nsamples);

# We use the transformation to obtain the posterior from the chain.

posterior = TransformVariables.transform.(Ref(problem_transformation(p)), get_position.(chain));

# Effective sample sizes (of untransformed draws)

ess = mapslices(effective_sample_size,
                get_position_matrix(chain); dims = 1)

# NUTS-specific statistics

display(NUTS_statistics(chain))

# Stepsize

display(NUTS_tuned)

# Sample from 4 chains and store the draws in the a3d array

posterior = Vector{Array{NamedTuple{(:β, :σ ),Tuple{Array{Float64,1},
  Float64}},1}}(undef, Nchains)

for j in 1:Nchains
  chain, NUTS_tuned = NUTS_init_tune_mcmc(∇P, Nsamples);
  posterior[j] = TransformVariables.transform.(Ref(problem_transformation(p)), 
    get_position.(chain));
end;

# Create a3d

a3d = Array{Float64, 3}(undef, Nsamples, Ncoef+1, Nchains);
for j in 1:Nchains
  for i in 1:Nsamples
    a3d[i, 1:Ncoef, j] = values(posterior[j][i][1])
    a3d[i, Ncoef+1, j] = values(posterior[j][i][2])
  end
end

# Create MCMCChains object

cnames = vcat("alpha", ["beta[$i]" for i in 1:Nparms], "sigma")
chn_d = MCMCChains.Chains(a3d, cnames)

# Describe draws

describe(chn_d)
