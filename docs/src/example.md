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


We will walk through the code in the top-level script named Gaussian_Example.jl. In the first snippet, we call the required packages, set the number of chains to 4, set the file directory as the project directory, remove old the old CmdStan output director tmp and create a new one, then create a results folder if one does not already exist.  

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

In the following code snippet, we set the path to the Gaussian model file and load them on each of the workers. Next, we suppress the printing of Turing's progress and set a seed on each worker.

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

The follow snippet creates a tuple of samplers and initializes a CmdStan output folder for each worker.

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

At this point, we can define the benchmark design. The design configuration is collected in the `NamedTuple` called options. MCMCBenchmarks will perform `Nrep = 50` repetitions for each combinations of factors defined in options. The number of combinations is computed as: `prod(length.(values(options)))`. In this example, there are three combinations:

* (Nsamples=2000,Nadapt=1000,delta=.8,Nd=10)
* (Nsamples=2000,Nadapt=1000,delta=.8,Nd=100)
* (Nsamples=2000,Nadapt=1000,delta=.8,Nd=1000)

If we set `delta = [.65, .80]` instead of `delta = .80`, there would be 6 combinations.

```julia
#Number of data points
Nd = [10, 100, 1000]

#Number of simulations
Nreps = 50

options = (Nsamples=2000,Nadapt=1000,delta=.8,Nd=Nd)
```

The function `pbenchmark` performs the benchmarks in parallel, by dividing the jobs across the available processors. `pbenchmark` accepts the tuple of samplers, the data generating function, the number of repetitions, and the design options. Upon completion, a `DataFrame` containing the benchmarks and configuration information is returned. 

```julia  
#perform the benchmark
results = pbenchmark(samplers,simulateGaussian,Nreps;options...)
```

After the benchmark has completed, the results are saved in the results as a csv file. In addition, relevant package version information and system information is saved in a seperate csv file.

```julia
#save results
save(results,ProjDir)
```
### Results Output
The following information is stored in the results `DataFrame`:

* Each parameter is associated with a column for each of the following quantities: Effective Sample Size, Effective Sample Size per second, cross-sampler r̂
* A sampler name column
* The column for each design element in the options `NamedTuple`
* A column for each of following performance metrics: run time, % garbage collection time, number of memory allocations, the amount of memory allocated in MB
