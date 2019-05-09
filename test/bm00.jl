using CmdStan, Random, BenchmarkTools

Random.seed!(38445)

ProjDir = @__DIR__
cd(ProjDir)

suite = BenchmarkGroup()

suite["cmdstan"] = BenchmarkGroup(["math", "triangles"])

for f in (sin, cos, tan)
    for x in (0.0, pi)
        suite["trig"][string(f), x] = @benchmarkable $(f)($x)
    end
end

tune!(suite);

results = run(suite, verbose = true, seconds = 1)

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
   y ~ normal(mu,sigma);
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
