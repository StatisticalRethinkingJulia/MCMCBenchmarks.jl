# MCMCBenchmarks.jl Documentation

*A flexible package for benchmarking MCMC samplers in Julia.*

## Introduction

Welcome to the documentation for MCMCBenchmarks, a benchmarking package for MCMC samplers written in the Julia language. Below, you will find an overview of features, the outline of the documentation, and an index of functions provided within MCMCBenchmarks. Use the navigation panel to your left to find more detailed information, including a fully annotated example for creating a benchmark, and results from our benchmark suite.

Please report bugs, issues and feature requests using the GitHub [issue tracker](https://github.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl/issues). Be sure to describe the nature of the problem and include a minimum working example if possible. We also welcome models to add to the benchmark suite, which can be submitted via a pull request.

## Features

* Flexible: specify factors to vary in your benchmark, such as number of MCMC samples, MCMC configuration, the size of datasets, and data generating parameters
* Parallel: distribute your benchmark over multiple processors to produce efficient benchmarks
* Extendable: use multiple dispatch to benchmark new samplers
* Performance Metrics: r̂, effective sample size, effective sample size per second, run time, percentage of time in garbage collection, MBs of memory allocated, number of memory allocations.
* Plots: density plots, summary plots, scatter plots, parameter recovery plots



```@contents
Pages = [
    "src/index.md",
    "src/purpose.md",
    "src/design.md",
    "src/example.md",
    "src/functions.md",
    "src/benchmarks.md",
]
Depth = 1
```

## Index
```@index
```
