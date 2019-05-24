@model AHMCGaussian(y,N) = begin
    mu ~ Normal(0,1)
    sigma ~ Truncated(Cauchy(0,5),0,Inf)
    for n = 1:N
        y[n] ~ Normal(mu,sigma)
    end
end

AHMCconfig = Turing.NUTS(2000,1000,.85)

@model DNGaussian(y,N) = begin
    mu ~ Normal(0,1)
    sigma ~ Truncated(Cauchy(0,5),0,Inf)
    for n = 1:N
        y[n] ~ Normal(mu,sigma)
    end
end

DNconfig = DynamicNUTS(2000)

CmdStanGaussian = "
data {
  int<lower=0> N;
  vector[N] y;
}
parameters {
  real mu;
  real<lower=0> sigma;
}
model {
  mu ~ normal(0,1);
  sigma ~ cauchy(0,5);
  y ~ normal(mu,sigma);
}
"

CmdStanConfig = Stanmodel(name = "CmdStanGaussian",model=CmdStanGaussian,nchains=1,
   Sample(num_samples=1000,num_warmup=1000,adapt=CmdStan.Adapt(delta=0.8),
   save_warmup = false))

   struct GaussianProb{TY <: AbstractVector}
      "Observations."
      y::TY
  end

  function (problem::GaussianProb)(θ)
      @unpack y = problem   # extract the data
      @unpack mu, sigma = θ
      loglikelihood(Normal(mu, sigma), y) + logpdf(Normal(0.1), mu) +
      logpdf(Truncated(Cauchy(0,5),0,Inf), sigma)
  end;

  # Define problem with data and inits.
  function sampleDHMC(obs,N,nsamples)
    p = GaussianProb(obs);
    p((mu = 0.0, sigma = 1.0))

    # Write a function to return properly dimensioned transformation.

    problem_transformation(p::GaussianProb) =
        as((mu  = as(Real, -25, 25), sigma = asℝ₊), )

    # Use Flux for the gradient.

    P = TransformedLogDensity(problem_transformation(p), p)
    ∇P = LogDensityRejectErrors(ADgradient(:ForwardDiff, P));

    # FSample from the posterior.

    chain, NUTS_tuned = NUTS_init_tune_mcmc(∇P, nsamples);

    # Undo the transformation to obtain the posterior from the chain.

    posterior = TransformVariables.transform.(Ref(problem_transformation(p)), get_position.(chain));

    # Set varable names, this will be automated using θ

    parameter_names = ["mu", "sigma"]

    # Create a3d

    a3d = Array{Float64, 3}(undef, 2000, 2, 1);
    for i in 1:2000
      a3d[i, 1, 1] = values(posterior[i][1])
      a3d[i, 2, 1] = values(posterior[i][2])
    end

    chns = MCMCChains.Chains(a3d,
      parameter_names,
      Dict(
        :parameters => parameter_names,
      )
    )

    return chns
  end

function GaussianGen(;μ=0,σ=1,Nd,kwargs...)
    data=(y=rand(Normal(μ,σ),Nd),N=Nd)
      return data
 end
