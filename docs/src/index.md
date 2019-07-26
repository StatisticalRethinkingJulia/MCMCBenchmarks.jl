# MCMCBenchmarks.jl Documentation


```@contents
```

## Purpose

MCMCBenchmarks.jl aims to accomplish three goals: (1) help Julia users decide which MCMC samplers to use on the basis of performance, (2) help Julia developers identify performance issues, and (3) provide a flexible framework for benchmarking models and samplers aside from those included in the package.

## Benchmarking Challenges

One of the challenges with benchmarking MCMC samplers is the lack of uniform interface. Some samplers may require different arguments or require different configurations because they are associated with different packages. In addition, models used for benchmarking often differ in terms of parameters, data structure, and function arguments. Without a unifying framework, benchmarking MCMC samplers can be cumbersome, resulting in limited re-use of code brittle and instability. Our goal in developing MCMCBenchmarks was to full the need for a unifying framework

## Basic Design

MCMCBenchmarks uses a combination of multiple dispatch and optional keyword arguments to satisfy the differing requirements of MCMC samplers and models. Benchmark routines are performed with three primary functions:

* runSampler: passes necessary arguments to sampler and runs the sampler

* updateResults: adds benchmark performance data to a results DataFrame

* modifyConfig: modifies the configuration of the sampler

These functions are overloaded with sampler-specific methods, ensuring that the requirements for each sampler are satisfied. Addtional flexibility is gained through the use of Optional keyword arguments. For any given method, relevant keywords are "captured", whereas irrelevant keywords are collected in "kwargs..." and ignored.

## Features


## Sampler Structs

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

```@docs
pbenchmark
```

```@docs
benchmark!
```

### Benchmark routines

```@docs
modifyConfig!
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

## Index

```@index
```
