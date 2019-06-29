@model AHMCpoisson(total_tools, log_pop, society) = begin
    N = length(total_tools)
    a0 ~ Normal(0, 10)
    a1 ~ Normal(0, 1)
    a0_sig ~ Truncated(Cauchy(0, 1), 0, Inf)
    N_society = length(unique(society)) #10
    a0s = Vector{Real}(undef, N_society)
    a0s ~ [Normal(0, a0_sig)]
    for i ∈ 1:N
        λ = exp(a0 + a0s[society[i]] + a1*log_pop[i])
        total_tools[i] ~ Poisson(λ)
    end
end

AHMCconfig = Turing.NUTS(2000,1000,.85)

@model DNpoisson(y,log_pop,society) = begin
    N = length(total_tools)
    a0 ~ Normal(0, 10)
    a1 ~ Normal(0, 1)
    a0_sig ~ Truncated(Cauchy(0, 1), 0, Inf)
    N_society = length(unique(society)) #10
    a0s = Vector{Real}(undef, N_society)
    a0s ~ [Normal(0, a0_sig)]
    for i ∈ 1:N
        λ = exp(a0 + a0s[society[i]] + a1*log_pop[i])
        total_tools[i] ~ Poisson(λ)
    end
end

function simulateHierPoisson(;Nd,Ns,a0,a1,a0_sig,kwargs...)
    Nobs = Nd*Ns
    y = fill(0.0,Nobs)
    log_pop = similar(y)
    society = fill(0,Nobs)
    i = 0
    for s in 1:Ns
        a0s = rand(Normal(0,a0_sig))
        logpop = rand(Normal(9,1.5))
        λ = exp(a0 + a0s + a1*logpop)
        for nd in 1:Nd
            i+=1
            log_pop[i] = logpop
            society[i] = s
            y[i] = rand(Poisson(λ))
        end
    end
    return (y=y,log_pop=log_pop,society=society)
 end

DNconfig = DynamicNUTS(2000)

CmdStanPoisson = "
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

CmdStanConfig = Stanmodel(name = "CmdStanPoisson",model=CmdStanRegression,nchains=1,
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
      sum(logpdf.(Normal.(μ,sigma),y)) + logpdf(Normal(0,10),B0) +
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
