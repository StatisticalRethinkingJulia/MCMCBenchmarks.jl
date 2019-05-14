# Import libraries.
push!(LOAD_PATH,pwd())
using Revise,Turing,Random,LinearBallisticAccumulator
using StatsPlots,LogDensityProblems,DynamicHMC

dist = LBA(;ν=[3.0,2.0],A=.8,k=.2,τ=.3)
data = rand(dist,100)

@model model(data) = begin
    mn=minimum(x->x[2],data)
    τ ~ TruncatedNormal(.3,.1,0.0,mn)
    A ~ TruncatedNormal(.8,.4,0.0,Inf)
    k ~ TruncatedNormal(.2,.3,0.0,Inf)
    υ1 ~ Normal(0,3)
    υ2 ~ Normal(0,3)
    N = length(data)
    for n in 1:N
        data[n] ~ LBA(;ν=[υ1,υ2],τ=τ,A=A,k=k)
    end
end

# Settings of the Hamiltonian Monte Carlo (HMC) sampler.
Nsamples = 2000
δ = .8
Nadapt = 1000
specs =  DynamicNUTS(Nsamples)#NUTS(Nsamples,Nadapt,δ)
# Start sampling.
@elapsed chain = sample(model(data),specs)

# Construct summary of the sampling process for the parameter p, i.e. the probability of heads in a coin.
v1 = Chains(chain[:k])
histogram(v1)
# Construct summary of the sampling process for the parameter p, i.e. the probability of heads in a coin.
v1 = Chains(chain[:τ])
histogram(v1)

v1=chain[:τ]
v2 = chain[:A]
plot(chain)
