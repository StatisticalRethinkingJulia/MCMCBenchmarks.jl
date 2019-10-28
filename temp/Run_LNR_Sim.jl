using Distributions, Turing, Random, Parameters
ProjDir = @__DIR__
cd(ProjDir)
include("LNR.jl")

@model model(data,Nr) = begin
    μ = Array{Real,1}(undef,Nr)
    μ ~ [Normal(0,3)]
    σ ~ Truncated(Normal(0, 1), 0, Inf)
    for i in 1:length(data)
        data[i] ~ LNR(μ, σ, 0.0)
    end
end

Random.seed!(343)
Nreps = 30
error_count = fill(0.0,Nreps)
Nr = 3

for i in 1:Nreps
    μ = rand(Normal(0 ,3), Nr)
    σ = rand(Uniform(.5, 2))
    dist = LNR(μ=μ, σ=σ, ϕ=0.0)
    data = rand(dist, 30)
    chain = sample(model(data, Nr), NUTS(1000, .8), 2000, discard_adapt = false, progress = false)
    error_count[i] = sum(get(chain,:numerical_error)[1])
end

describe(error_count)
