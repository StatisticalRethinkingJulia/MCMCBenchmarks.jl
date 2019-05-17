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

MCMCBenchmarks (WIP) provides a flexable yet lightweight framework for benchmarking MCMC samplers in terms of runtime, convergence metrics and effective sample size. Currently, MCMCBenchmarks provides out of the box support for benchmarking the NUTS algorithm as instantiated in CmdStan, DynamicHMC, AdvancedHMC/Turing. However, methods can be extended to acommodate other samplers and any test model.

Our plan to provide a suite of test models that span a wide range of difficulty. The table provides a partial list of test model that will be included in the suite as well as their current development status, ordered approximately from easist to most difficult:  

- Gaussian Model: simple two parameter Gaussian distribution
- Signal Detection Model: a simple model used in psychophysics and signal processing, which decomposes performance in terms of descriminability and bias
- Linear Regession Model
- Hierarchical Poisson Regression
- Linear Ballistic Accumulator: a cognitive model of perception and simple decision making. 

| Model                           | Author | Turing  | DynamicHMC       | DynamicNUTS               | CmdStan |
|---------------------------------|--------|---------|------------------|---------------------------|---------|
| Gaussian Model                  | Chris  | Working | Working          | Working                   | Working |
| Signal Detection Theory         | Chris  | Working | Errors out       | Hard crash due  to NaN    | Working |
| Linear Regression               | Rob    |         |                  |                           |         |
| Hierarchical Poisson Regression | Rob    |         |                  |                           |         |
| Linear Ballistic Accumulator    | Chris  | Working | Non-finite error | density start point error | Working |

In the links below, you will find preliminary results for a simple Gaussian model. 

[Performance comparison on sample size](https://github.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl/blob/master/Examples/Gaussian/results/Mean%20Time.pdf)

[Performance distribution on sample size](https://github.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl/blob/master/Examples/Gaussian/results/Time%20Dist.pdf)

[Diagnostics comparison of estimated ess values ](https://github.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl/blob/master/Examples/Gaussian/results/Mu%20ESS%20Dist.pdf)

[Diagnostics comparison of rhat estimates ](https://github.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl/blob/master/Examples/Gaussian/results/Mu%20rhat%20Dist.pdf)

[Diagnostics comparison leapfrog stepsizes ](https://github.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl/blob/master/Examples/Gaussian/results/Mu%20Epsilon%20Scatter.pdf)
