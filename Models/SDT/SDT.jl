@model SDTmodel(data) = begin
    d ~ Normal(0,1/sqrt(2))
    c ~ Normal(0,1/sqrt(2))
    data ~ SDT(d,c)
end

AHMC_SDT(hits,fas,Nd) = SDTmodel((hits,fas,Nd))

AHMCconfig = Turing.NUTS(2000,1000,.85)

DN_SDT(hits,fas,Nd) = SDTmodel((hits,fas,Nd))

DNconfig = DynamicNUTS(2000)

CmdStan_SDT = "
data {
  int<lower=1> Nd;
  int<lower=0> hits;
  int<lower=0> fas;
}
parameters {
  real d;
  real c;
}

model {
  real thetah;
  real thetaf;

  d ~ normal(0, inv_sqrt(.5));
  c ~ normal(0, inv_sqrt(2));

  thetah = Phi(d/2-c);
  thetaf = Phi(-d/2-c);

  // Observed counts
  hits ~ binomial(Nd, thetah);
  fas ~ binomial(Nd, thetaf);
}
"

CmdStanConfig = Stanmodel(name = "CmdStan_SDT",model=CmdStan_SDT,nchains=1,
   Sample(num_samples=1000,num_warmup=1000,adapt=CmdStan.Adapt(delta=0.8),
   save_warmup = false))

  struct SDTProblem
      hits::Int64
      fas::Int64
      Nd::Int64
  end

  function (problem::SDTProblem)(θ)
      @unpack hits,fas,Nd=problem   # extract the data
      @unpack d,c=θ
      logpdf(SDT(d,c),[hits,fas,Nd])+logpdf(Normal(0,1/sqrt(2)),d) +
      logpdf(Normal(0,1/sqrt(2)),c)
  end

  # Define problem with data and inits.
  function sampleDHMC(hits,fas,Nd,Nsamples)
    p = SDTProblem(hits,fas,Nd)
    p((d=2.0,c=.0))
    # Write a function to return properly dimensioned transformation.
    problem_transformation(p::SDTProblem) =
         as((d=asℝ,c=asℝ))
    # Use Flux for the gradient.
    P = TransformedLogDensity(problem_transformation(p), p)
    ∇P = LogDensityRejectErrors(ADgradient(:ForwardDiff, P));
    # FSample from the posterior.
    chain, NUTS_tuned = NUTS_init_tune_mcmc(∇P,Nsamples,report=ReportSilent());
    # Undo the transformation to obtain the posterior from the chain.
    posterior = TransformVariables.transform.(Ref(problem_transformation(p)), get_position.(chain));
    chns = nptochain(posterior,NUTS_tuned)
    return chns
  end

  function simulateSDT(;d=2.,c=0.,Nd,kwargs...)
      θhit=cdf(Normal(0,1),d/2-c)
      θfa=cdf(Normal(0,1),-d/2-c)
      hits = rand(Binomial(Nd,θhit))
      fas = rand(Binomial(Nd,θfa))
        return (hits=hits,fas=fas,Nd=Nd)
   end
