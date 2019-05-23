using MCMCBenchmarks

include("../../../Models/Gaussian/Gaussian_Models.jl")

@model AHMCGaussian(y,N) = begin
    mu ~ Normal(0,1)
    sigma ~ Truncated(Cauchy(0,5),0,Inf)
    for n = 1:N
        y[n] ~ Normal(mu,sigma)
    end
end

AHMCconfig = Turing.NUTS(2000,1000,.85)

# Sampling

BenchmarkTools.DEFAULT_PARAMETERS.samples = 50

Nsamples=2000
Nadapt=1000
delte=0.85

Ns = [100, 1000]

chns = Vector{MCMCChains.Chains}(undef, length(Ns))
t = Vector{BenchmarkTools.Trial}(undef, length(Ns))

for (i, N) in enumerate(Ns)
  data = Dict("y" => rand(Normal(0,1),N), "N" => N)
  modifyConfig!(s::AHMCNUTS;Nsamples,Nadapt,delta,kwargs...)
  t[i] = @benchmark runSampler(s::AHMCNUTS,data;kwargs...)
  samples = AHMCNUTS(AHMCGaussian, AHMCconfig)
end

t[1] |> display
println()
t[end] |> display
