using Distributions, CmdStan, Random, Parameters, StatsFuns
ProjDir = @__DIR__
cd(ProjDir)

stream = open("Logit_Normal.stan","r")
Model = read(stream,String)
close(stream)
seed = 343

stanmodel = Stanmodel(Sample(save_warmup=false, num_warmup=1000,
  num_samples=1000, thin=1), nchains=1, name="Logit_Normal", model=Model,
  printsummary=false, output_format=:mcmcchains, random=CmdStan.Random(seed))

Nsub = 3000
N = 400
ps = logistic.(rand(Normal(-2, 0.8), Nsub))
y = rand.(Binomial.(N, ps))

stanInput = Dict("N"=>N, "Nsub"=>Nsub, "y"=>y)
@time rc, chain, cnames = stan(stanmodel, stanInput, ProjDir)
