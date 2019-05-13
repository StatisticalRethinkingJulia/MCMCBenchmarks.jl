using MCMCBenchmarks
import Distributions: logpdf

Random.seed!(38445)

ProjDir = @__DIR__
cd(ProjDir)

 mutable struct mydist{T1,T2} <: ContinuousUnivariateDistribution
     μ::T1
     σ::T2
 end

 function logpdf(dist::mydist,data::Array{Float64,1})
     @unpack μ,σ=dist
     
     LL = 0.0
     for d in data
         LL += logpdf(Normal(μ,σ),d)
     end
     isnan(LL) ? (return Inf) : (return LL) #not as robust as I thought
     #loglikelihood(Normal(μ, σ), data)
     LL
 end

 #Function barrier in mydist
 @model model(y) = begin
     μ ~ Normal(0,1)
     σ ~ Truncated(Cauchy(0,1),0,Inf)
     y ~ mydist(μ,σ)
 end

 @model model1(y) = begin
     μ ~ Normal(0,1)
     σ ~ Truncated(Cauchy(0,1),0,Inf)
     N = length(y)
     for n in 1:N
         y[n] ~ Normal(μ,σ)
     end
 end

Nsamples = 2000
Nadapt = 1000
Nchains = 1

# Quite possible the simulations will fail with:
# "LoadError: InvalidLogDensityException: value is NaN"
# For now limit no of benchmark to a too low no of samples
# YMMV!!!
BenchmarkTools.DEFAULT_PARAMETERS.samples = 3

Ns = [100, 500]
t = Vector{BenchmarkTools.Trial}(undef, length(Ns))
for (i, N) in enumerate(Ns)
  data = Dict("y" => rand(Normal(0,1),N), "N" => N)
  t[i] = @benchmark sample(model($(data["y"])), $(DynamicNUTS(Nsamples)))
end

t[1] |> display
println()
t[end]