## Sampler Structs

Each sampler is associated with a MCMC sampler struct, which is a subtype of MCMCSampler. In MCMCBenchmarks, we define subtypes of MCMCSampler for three popular NUTS MCMC samplers in Julia: [CmdStan](https://github.com/StanJulia/CmdStan.jl), [AdvancedHMC](https://github.com/TuringLang/AdvancedHMC.jl) via [Turing](https://turing.ml), and [DynamicHMC](https://github.com/tpapp/DynamicHMC.jl).

```@docs
MCMCSampler
```

```@docs
CmdStanNUTS
```

```@docs
AHMCNUTS
```

```@docs
DHMCNUTS
```

## Functions

### Top-level Benchmark Routines

```@docs
benchmark

```julia
benchmark!(samplers,results,csr̂,simulate,Nreps,chains;kwargs...)

benchmark!(sampler::T,results,csr̂,simulate,Nreps,chains;kwargs...) where {T<:MCMCSampler}
```
```

```@docs
pbenchmark
```

```@docs
benchmark!
```

### Overloaded Benchmark Functions

```@docs
modifyConfig!
```

```@docs
updateResults!
```

```@docs
runSampler
```

### Helper Functions

```@docs
addPerformance!
```

```@docs
addKW!
```

```@docs
addChainSummary!
```

```@docs
addHPD!
```

```@docs
addMeans!
```
### Plotting

```@docs
plotdensity
```
```@docs
plotsummary
```
```@docs
plotscatter
```
```@docs
plotrecovery
```
## Results DataFrame
