# MCMCBenchmarks

![Lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)<!--
![Lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-stable-green.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-retired-orange.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-archived-red.svg)
![Lifecycle](https://img.shields.io/badge/lifecycle-dormant-blue.svg) -->
[![Build Status](https://travis-ci.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl.svg?branch=master)](https://travis-ci.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl)
[![codecov.io](http://codecov.io/github/StatisticalRethinkingJulia/MCMCBenchmarks.jl/coverage.svg?branch=master)](http://codecov.io/github/StatisticalRethinkingJulia/MCMCBenchmarks.jl?branch=master)


## Introduction

MCMCBenchmarks provides a lightweight yet flexible framework for benchmarking MCMC samplers in terms of runtime, memory usage, convergence metrics and effective sample size. Currently, MCMCBenchmarks provides out of the box support for benchmarking the [No-U-Turn Sampler](http://jmlr.org/papers/volume15/hoffman14a/hoffman14a.pdf) (NUTS) algorithm as implemented in [CmdStan](https://github.com/StanJulia/CmdStan.jl), [DynamicHMC](https://github.com/tpapp/DynamicHMC.jl) and [AdvancedHMC](https://github.com/TuringLang/AdvancedHMC.jl) via [Turing](https://github.com/TuringLang/Turing.jl). However, methods can be extended to accommodate other samplers and test models. Click [here](https://statisticalrethinkingjulia.github.io/MCMCBenchmarks.jl/latest/benchmarks/) to see an overview of key benchmarking results.
## Documentation

- [**Docs**][docs-dev-url] &mdash; *documentation of the in-development version.*

## Overview of Features
- Benchmarking Parameters: vary factors such as sample size, data-generating parameters, prior distributions, and target acceptance rate. The use of optional keywords allows other benchmarking parameters to be varied.
- Plotting: generate and save plots comparing samplers in terms of run time, memory usage, convergence diagnostics and effective sample size.
- Test Suite: a suite of test models that span a wide range of difficulty.

## Test Suite
MCMCBenchmarks includes a test suite of models spanning a wide range of difficulty. Each model is listed below, ordered approximately from easiest to most difficult:  

- [Gaussian Model](https://en.wikipedia.org/wiki/Normal_distribution): simple two parameter Gaussian distribution
- [Signal Detection Model](https://en.wikipedia.org/wiki/Detection_theory): a simple model used in psychophysics and signal processing, which decomposes performance in terms of discriminability and bias
- [Linear Regession Model](https://en.wikipedia.org/wiki/Linear_regression)
- Hierarchical Poisson Regression
- [Linear Ballistic Accumulator](http://www.tascl.org/uploads/4/9/3/3/49339445/38_.pdf): a cognitive model of perception and simple decision making.

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://statisticalrethinkingjulia.github.io/MCMCBenchmarks.jl/latest

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://statisticalrethinkingjulia.github.io/MCMCBenchmarks.jl/stable
