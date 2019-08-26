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
```
```julia
benchmark!(samplers,results,csr̂,simulate,Nreps,chains;kwargs...)

benchmark!(sampler::T,results,csr̂,simulate,Nreps,chains;kwargs...) where {T<:MCMCSampler}
```

```@docs
pbenchmark
```
```julia
pbenchmark(samplers,simulate,Nreps;kwargs...)

```

```@docs
benchmark!
```
```julia
benchmark!(samplers,results,csr̂,simulate,Nreps,chains;kwargs...)
```

### Overloaded Benchmark Functions

```@docs
modifyConfig!
```
```julia
modifyConfig!(s::AHMCNUTS;Nsamples,Nadapt,delta,kwargs...)
```

```@docs
updateResults!
```
```julia
updateResults!(s::CmdStanNUTS,performance,results;kwargs...)
```

```@docs
runSampler
```
```julia
 runSampler(s::AHMCNUTS,data;kwargs...)
 ```

### Helper Functions

```@docs
addPerformance!
```
```julia
addPerformance!(df,p)
```

```@docs
addKW!
```
```julia
addKW!(df;kwargs...)
```

```@docs
addChainSummary!
```
```julia
addChainSummary!(newDF,chn,df,col)
```

```@docs
addHPD!
```
```julia
addHPD!(newDF,chain)
```

```@docs
addMeans!
```
```julia
addMeans!(newDF,df)
```
### Plotting

```@docs
plotdensity
```

```julia
plotdensity(df::DataFrame,metric::Symbol,group=(:sampler,);save=false,
    figfmt="pdf",dir="",options...)
```
```@docs
plotsummary
```
```julia
plotsummary(df::DataFrame,xvar::Symbol,metric::Symbol,group=(:sampler,);save=false,
    figfmt="pdf",func=mean,dir="",options...)
```

```@docs
plotscatter
```
```julia
plotscatter(df::DataFrame,xvar::Symbol,metric::Symbol,group=(:sampler,);save=false,
    figfmt="pdf",func=mean,dir="",options...)
```
```@docs
plotrecovery
```

```julia
plotrecovery(df::DataFrame,parms,group=(:sampler,);save=false,
    figfmt="pdf",dir="",options...)
```
