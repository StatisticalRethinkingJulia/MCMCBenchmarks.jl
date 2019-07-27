## Example

### Model

In this detailed example, we will guide users through the process of developing a benchmark within MCMCBenchmarks. To make matters as simple as possible, we will benchmark CmdnStan, AdvancedHMC, and DynamicHMC with a simple Gaussian model. Assume that a vector of observations Y follows a Gaussian distribution with parameters μ and σ, which have Gaussian and Truncated Cauchy prior distributions, respectively. Formally, the Gaussian model is defined as follows:

"""
\\mu ~ Normal(0,1)
\\sigma ~ TCauchy(0,5,0,\infty)
\Y ~ Normal(\mu,\sigma)
"""
### Benchmark Design

In this example, we will generate data from a Gaussian distribution with parameters μ = 0 and σ = 1 for three sample sizes Nd = [10, 100, 1000]. Each sampler will run for Nsamples = 2000 iterations, Nadapt = 1000 of which are adaption or warmup iterations. The target acceptance rate is set to delta = .8. The benchmark will be repeated 50 times with a different sample of simulated data to ensure that the results are robust across datasets. This will result in 450 benchmarks, (3 (samplers) X 3 (sample sizes) X 50 (repetitions)).

### Code Structure

In order to perform a benchmark, the user must define the following:

* A top-level script for calling the necessary functions and specifying the benchmark design. The corresponding code can be found in MCMCBenchmarks/Examples/Gaussian/Gaussian_Example.jl.

* Models defined for each of the samplers with a common naming scheme for parameters. The corresponding code can be found in MCMCBenchmarks/Models/Gaussian/Gaussian_Models.jl.

* Sampler specific struct and methods defined for updateResults!, modifyConfig!, and runSampler. Structs and methods for NUTS in CmdStan, AdvancedHMC/Turing, and DynamicHMC are provided by MCMCBenchmarks.


Walk through the components top level code

```julia
using Revise,MCMCBenchmarks,Distributed
Nchains=4
setprocs(Nchains)

ProjDir = @__DIR__
cd(ProjDir)

isdir("tmp") && rm("tmp", recursive=true)
mkdir("tmp")
!isdir("results") && mkdir("results")
```


```julia
path = pathof(MCMCBenchmarks)
@everywhere begin
  using MCMCBenchmarks,Revise
  #Model and configuration patterns for each sampler are located in a
  #seperate model file.
  include(joinpath($path, "../../Models/Gaussian/Gaussian_Models.jl"))
end

#run this on primary processor to create tmp folder
include(joinpath(path,
  "../../Models/Gaussian/Gaussian_Models.jl"))

@everywhere Turing.turnprogress(false)
#set seeds on each processor
seeds = (939388,39884,28484,495858,544443)
for (i,seed) in enumerate(seeds)
    @fetch @spawnat i Random.seed!(seed)
end

```

```julia
#create a sampler object or a tuple of sampler objects
samplers=(
  CmdStanNUTS(CmdStanConfig,ProjDir),
  AHMCNUTS(AHMCGaussian,AHMCconfig),
  DHMCNUTS(sampleDHMC,2000))

stanSampler = CmdStanNUTS(CmdStanConfig,ProjDir)
#Initialize model files for each instance of stan
initStan(stanSampler)
```

```julia
#Number of data points
Nd = [10, 100, 1000]

#Number of simulations
Nreps = 50

options = (Nsamples=2000,Nadapt=1000,delta=.8,Nd=Nd)

#perform the benchmark
results = pbenchmark(samplers,simulateGaussian,Nreps;options...)
```



### Output  

```julia
#save results
save(results,ProjDir)

pyplot()
cd(pwd)
dir = "results/"
```
