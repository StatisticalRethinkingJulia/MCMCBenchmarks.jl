using CmdStan, Random, BenchmarkTools

Random.seed!(38445)

ProjDir = @__DIR__
cd(ProjDir)

 normstanmodel = "
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
   sigma ~ cauchy(0,1);
   y ~ normal(mu, sigma);
 }
 "

 BenchmarkTools.DEFAULT_PARAMETERS.samples = 25
 
 Nsamples = 2000
 Nadapt = 1000
 Nchains = 1

stanmodel = Stanmodel(
   name = "normstanmodel", model = normstanmodel, nchains = Nchains,
   Sample(num_samples = Nsamples, num_warmup = Nadapt,
     adapt = CmdStan.Adapt(delta=0.8),
     save_warmup = false));

function cmdstan_bm(stanmodel, N,
  data=Dict("y" => rand(Normal(0, 1), N), "N" => N),
  ProjDir = ProjDir)
    
  stan(stanmodel, data, summary=false, ProjDir)
  
end

Ns = [200, 500, 1000]
t = Vector{BenchmarkTools.Trial}(undef, length(Ns))
for (i, N) in enumerate(Ns)
  t[i] = @benchmark cmdstan_bm(stanmodel, N)
end
