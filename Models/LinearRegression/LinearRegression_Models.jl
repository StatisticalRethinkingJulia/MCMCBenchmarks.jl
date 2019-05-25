@model AHMCregression(x,y,Nd,Nc) = begin
    B = Array{Real}(undef,Nc)
    B ~ [Normal(0,10)]
    B0 ~ Normal(0,10)
    sigma ~ Truncated(Cauchy(0,5),0,Inf)
    mu = B0 .+ x*B
    for n = 1:Nd
        y[n] ~ Normal(mu[n],sigma)
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

#Include DynamicHMC model if you want it in a separate file to make things cleaner
#include("lr_dHMC/lr.jl")

function simulateRegression(;Nd,Nc,β0=1.,β=fill(.5,Nc),σ=1,kwargs...)
    x = rand(Normal(10,5),Nd,Nc)
    y = β0 .+ x*β .+ rand(Normal(0,σ),Nd)
    return (x=x,y=y,Nd=Nd,Nc=Nc)
 end
