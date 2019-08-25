# Example

## Model

In this detailed example, we will guide users through the process of developing a benchmark within MCMCBenchmarks. To make matters as simple as possible, we will benchmark CmdnStan, AdvancedHMC, and DynamicHMC with a simple Gaussian model. Assume that a vector of observations Y follows a Gaussian distribution with parameters μ and σ, which have Gaussian and Truncated Cauchy prior distributions, respectively. Formally, the Gaussian model is defined as follows:


```math
\mu \sim Normal(0,1)
```
```math
\sigma \sim TCauchy(0,5,0,\infty)
```
```math
Y \sim Normal(\mu,\sigma)
```

## Benchmark Design

In this example, we will generate data from a Gaussian distribution with parameters μ = 0 and σ = 1 for three sample sizes Nd = [10, 100, 1000]. Each sampler will run for Nsamples = 2000 iterations, Nadapt = 1000 of which are adaption or warmup iterations. The target acceptance rate is set to delta = .8. The benchmark will be repeated 50 times with a different sample of simulated data to ensure that the results are robust across datasets. This will result in 450 benchmarks, (3 (samplers) X 3 (sample sizes) X 50 (repetitions)).

## Code Structure

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
## Results Output
The following information is stored in the results `DataFrame`:

* Each parameter is associated with a column for each of the following quantities: Effective Sample Size, Effective Sample Size per second, cross-sampler r̂
* A sampler name column
* The column for each design element in the options `NamedTuple`
* A column for each of following performance metrics: run time, % garbage collection time, number of memory allocations, the amount of memory allocated in MB


```julia

│ Row │ mu_ess  │ mu_ess_ps │ mu_hdp_lb  │ mu_hdp_ub │ mu_mean    │ mu_r_hat │ sigma_ess │ sigma_ess_ps │ sigma_hdp_lb │ sigma_hdp_ub │ sigma_mean │ sigma_r_hat │
│     │ Float64 │ Float64   │ Float64    │ Float64   │ Float64    │ Float64  │ Float64   │ Float64      │ Float64      │ Float64      │ Float64    │ Float64     │
├─────┼─────────┼───────────┼────────────┼───────────┼────────────┼──────────┼───────────┼──────────────┼──────────────┼──────────────┼────────────┼─────────────┤
│ 1   │ 453.183 │ 1101.93   │ -0.439951  │ 1.01233   │ 0.335121   │ 1.01192  │ 561.67    │ 1365.72      │ 0.694345     │ 1.85464      │ 1.20432    │ 0.999773    │
│ 2   │ 439.956 │ 1197.47   │ -0.345675  │ 1.05657   │ 0.29728    │ 1.01183  │ 349.387   │ 950.962      │ 0.680205     │ 1.96625      │ 1.2538     │ 0.999099    │
│ 3   │ 750.97  │ 6877.37   │ -0.418789  │ 0.98444   │ 0.315015   │ 1.00147  │ 436.824   │ 4000.43      │ 0.685377     │ 1.88949      │ 1.20968    │ 1.00001     │
│ 4   │ 627.599 │ 1585.39   │ -0.465991  │ 0.419506  │ -0.0264066 │ 1.00156  │ 687.419   │ 1736.51      │ 0.41708      │ 1.11226      │ 0.723098   │ 1.0025      │
│ 5   │ 310.065 │ 762.221   │ -0.48833   │ 0.46412   │ -0.0270623 │ 0.999198 │ 375.669   │ 923.491      │ 0.354449     │ 1.16472      │ 0.747474   │ 0.99918     │
│ 6   │ 627.462 │ 4769.92   │ -0.516661  │ 0.409657  │ -0.0253033 │ 0.999118 │ 388.73    │ 2955.1       │ 0.406456     │ 1.11744      │ 0.743553   │ 0.999008    │
│ 7   │ 635.731 │ 1587.98   │ -0.271512  │ 0.854006  │ 0.275059   │ 1.0016   │ 576.698   │ 1440.52      │ 0.537828     │ 1.43556      │ 0.953825   │ 0.999986    │
⋮
│ 443 │ 987.146 │ 979.354   │ -0.107562  │ 0.0177224 │ -0.0454973 │ 0.999009 │ 916.509   │ 909.275      │ 0.960226     │ 1.04749      │ 1.00635    │ 0.999703    │
│ 444 │ 971.496 │ 1761.29   │ -0.105877  │ 0.0127306 │ -0.0453024 │ 0.999013 │ 608.395   │ 1103.0       │ 0.96735      │ 1.04969      │ 1.00694    │ 1.00024     │
│ 445 │ 951.84  │ 2159.27   │ -0.103468  │ 0.0207677 │ -0.0415093 │ 1.0003   │ 1000.0    │ 2268.53      │ 0.97463      │ 1.06208      │ 1.0171     │ 0.999189    │
│ 446 │ 948.782 │ 1164.19   │ -0.110913  │ 0.0170485 │ -0.0423884 │ 1.00133  │ 1000.0    │ 1227.04      │ 0.973883     │ 1.06253      │ 1.018      │ 0.999011    │
│ 447 │ 1000.0  │ 1758.8    │ -0.105022  │ 0.0154367 │ -0.043221  │ 1.00022  │ 370.093   │ 650.921      │ 0.968455     │ 1.06218      │ 1.01705    │ 0.999325    │
│ 448 │ 879.725 │ 1900.39   │ -0.0472455 │ 0.0761518 │ 0.0152611  │ 1.00018  │ 874.352   │ 1888.78      │ 1.00112      │ 1.09242      │ 1.04392    │ 0.999115    │
│ 449 │ 1000.0  │ 1367.86   │ -0.0394613 │ 0.0828844 │ 0.0163545  │ 0.999198 │ 1000.0    │ 1367.86      │ 1.00124      │ 1.08632      │ 1.04264    │ 1.00029     │
│ 450 │ 934.934 │ 1587.04   │ -0.0495172 │ 0.0814705 │ 0.0169015  │ 1.00209  │ 440.281   │ 747.371      │ 0.996308     │ 1.08719      │ 1.0428     │ 0.999471    │

│ Row │ epsilon  │ tree_depth │ time     │ megabytes │ gctime    │ gcpercent │ allocations │ sampler     │ Nsamples │ Nadapt │ delta   │ Nd    │ mu_sampler_rhat │
│     │ Float64  │ Float64    │ Float64  │ Float64   │ Float64   │ Float64   │ Int64       │ String      │ Int64    │ Int64  │ Float64 │ Int64 │ Float64         │
├─────┼──────────┼────────────┼──────────┼───────────┼───────────┼───────────┼─────────────┼─────────────┼──────────┼────────┼─────────┼───────┼─────────────────┤
│ 1   │ 0.769406 │ 2.113      │ 0.411262 │ 7.78675   │ 0.0       │ 0.0       │ 175314      │ CmdStanNUTS │ 2000     │ 1000   │ 0.8     │ 10    │ 1.00571         │
│ 2   │ 0.706563 │ 2.219      │ 0.367404 │ 233.422   │ 0.0741201 │ 0.20174   │ 2654525     │ AHMCNUTS    │ 2000     │ 1000   │ 0.8     │ 10    │ 1.00571         │
│ 3   │ 0.793221 │ 1.915      │ 0.109194 │ 58.6358   │ 0.0288007 │ 0.263756  │ 1530417     │ DHMCNUTS    │ 2000     │ 1000   │ 0.8     │ 10    │ 1.00571         │
│ 4   │ 0.853159 │ 1.842      │ 0.395863 │ 7.26259   │ 0.0       │ 0.0       │ 165981      │ CmdStanNUTS │ 2000     │ 1000   │ 0.8     │ 10    │ 0.999527        │
│ 5   │ 0.718885 │ 2.269      │ 0.406792 │ 236.96    │ 0.0790683 │ 0.19437   │ 2731926     │ AHMCNUTS    │ 2000     │ 1000   │ 0.8     │ 10    │ 0.999527        │
│ 6   │ 0.429143 │ 2.317      │ 0.131546 │ 71.1897   │ 0.0312859 │ 0.237833  │ 1877320     │ DHMCNUTS    │ 2000     │ 1000   │ 0.8     │ 10    │ 0.999527        │
│ 7   │ 0.779473 │ 1.906      │ 0.400339 │ 7.25304   │ 0.0       │ 0.0       │ 165982      │ CmdStanNUTS │ 2000     │ 1000   │ 0.8     │ 10    │ 0.999831        │
⋮
│ 443 │ 1.01321  │ 1.747      │ 1.00796  │ 583.327   │ 0.36536   │ 0.362476  │ 2056393     │ AHMCNUTS    │ 2000     │ 1000   │ 0.8     │ 1000  │ 0.999432        │
│ 444 │ 0.57954  │ 1.984      │ 0.551582 │ 503.207   │ 0.0783162 │ 0.141985  │ 1695754     │ DHMCNUTS    │ 2000     │ 1000   │ 0.8     │ 1000  │ 0.999432        │
│ 445 │ 0.91965  │ 1.8        │ 0.440815 │ 7.36456   │ 0.0       │ 0.0       │ 166982      │ CmdStanNUTS │ 2000     │ 1000   │ 0.8     │ 1000  │ 1.00027         │
│ 446 │ 0.810912 │ 1.816      │ 0.81497  │ 636.641   │ 0.118367  │ 0.145241  │ 2233313     │ AHMCNUTS    │ 2000     │ 1000   │ 0.8     │ 1000  │ 1.00027         │
│ 447 │ 0.622224 │ 2.014      │ 0.568569 │ 502.033   │ 0.0863364 │ 0.151849  │ 1689812     │ DHMCNUTS    │ 2000     │ 1000   │ 0.8     │ 1000  │ 1.00027         │
│ 448 │ 0.830561 │ 1.865      │ 0.462918 │ 7.3316    │ 0.0       │ 0.0       │ 166982      │ CmdStanNUTS │ 2000     │ 1000   │ 0.8     │ 1000  │ 1.00022         │
│ 449 │ 0.876156 │ 1.796      │ 0.731066 │ 637.126   │ 0.115552  │ 0.15806   │ 2234563     │ AHMCNUTS    │ 2000     │ 1000   │ 0.8     │ 1000  │ 1.00022         │
│ 450 │ 0.689293 │ 1.896      │ 0.589106 │ 455.712   │ 0.0896887 │ 0.152245  │ 1525902     │ DHMCNUTS    │ 2000     │ 1000   │ 0.8     │ 1000  │ 1.00022         │

│ Row │ sigma_sampler_rhat │
│     │ Float64            │
├─────┼────────────────────┤
│ 1   │ 1.00186            │
│ 2   │ 1.00186            │
│ 3   │ 1.00186            │
│ 4   │ 1.00135            │
│ 5   │ 1.00135            │
│ 6   │ 1.00135            │
│ 7   │ 1.00377            │
⋮
│ 443 │ 0.999586           │
│ 444 │ 0.999586           │
│ 445 │ 0.999321           │
│ 446 │ 0.999321           │
│ 447 │ 0.999321           │
│ 448 │ 0.999731           │
│ 449 │ 0.999731           │
│ 450 │ 0.999731           │
```
