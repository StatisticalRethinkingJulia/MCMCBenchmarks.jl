@model AHMCregression(x, y, Nd, Nc) = begin
    B ~ MvNormal(zeros(Nc), 10)
    B0 ~ Normal(0, 10)
    sigma ~ Truncated(Cauchy(0, 5), 0, Inf)
    mu = B0 .+ x * B
    y ~ MvNormal(mu, sigma)
end

AHMCconfig = Turing.NUTS(2000, 1000, .85)

CmdStanRegression = "
data {
  int<lower=0> Nd;
  int<lower=0> Nc;
  matrix[Nd,Nc] x;
  vector[Nd] y;
}
parameters {
  real B0;
  vector[Nc] B;
  real<lower=0> sigma;
}
model {
  vector[Nd] mu;
  mu = B0 + x*B;
  sigma ~ cauchy(0,5);
  B0 ~ normal(0,10);
  B ~ normal(0,10);
  y ~ normal(mu,sigma);
}
"

CmdStanConfig = Stanmodel(name = "CmdStanRegression",model=CmdStanRegression,nchains=1,
   Sample(num_samples=1000,num_warmup=1000,adapt=CmdStan.Adapt(delta=0.8),
   save_warmup=true))

   struct RegressionProb
      x::Array{Float64,2}
      y::Array{Float64,1}
      Nd::Int64
      Nc::Int64
  end

  function (problem::RegressionProb)(θ)
      @unpack x,y,Nd,Nc = problem   # extract the data
      @unpack B0,B,sigma = θ
      μ = B0 .+x*B
      logpdf(MvNormal(μ, sigma), y)  + logpdf(Normal(0,10),B0) +
      loglikelihood(Normal(0,10),B) + logpdf(Truncated(Cauchy(0,5),0,Inf),sigma)
  end

  # Define problem with data and inits.
  function sampleDHMC(x,y,Nd,Nc,nsamples)
    p = RegressionProb(x,y,Nd,Nc)
    p((B0=0.0,B=fill(0.0,Nc),sigma=1.0))

    # Write a function to return properly dimensioned transformation.

    problem_transformation(p::RegressionProb) =
        as((B0=asℝ,B=as(Array,asℝ,Nc), sigma = asℝ₊))
    # Use Flux for the gradient.

    P = TransformedLogDensity(problem_transformation(p), p)
    #∇P = LogDensityRejectErrors(ADgradient(:ForwardDiff, P))
    ∇P = ADgradient(:ForwardDiff, P)

    # FSample from the posterior.

    chain, NUTS_tuned = NUTS_init_tune_mcmc(∇P, nsamples,report=ReportSilent());

    # Undo the transformation to obtain the posterior from the chain.

    posterior = TransformVariables.transform.(Ref(problem_transformation(p)), get_position.(chain));
    chns = nptochain(posterior,NUTS_tuned)
    return chns
  end

  function simulateRegression(;Nd,Nc=1,β0=1.,β=fill(.5,Nc),σ=1,kwargs...)
      x = rand(Normal(10,5),Nd,Nc)
      y = β0 .+ x*β .+ rand(Normal(0,σ),Nd)
      return (x=x,y=y,Nd=Nd,Nc=Nc)
   end
