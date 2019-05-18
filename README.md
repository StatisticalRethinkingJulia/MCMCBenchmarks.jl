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

MCMCBenchmarks (WIP) provides a lightweight yet flexible framework for benchmarking MCMC samplers in terms of runtime, convergence metrics and effective sample size. Currently, MCMCBenchmarks provides out of the box support for benchmarking the [No-U-Turn Sampler](http://jmlr.org/papers/volume15/hoffman14a/hoffman14a.pdf) (NUTS) algorithm as instantiated in [CmdStan](https://github.com/StanJulia/CmdStan.jl), [DynamicHMC](https://github.com/tpapp/DynamicHMC.jl) and [AdvancedHMC](https://github.com/TuringLang/AdvancedHMC.jl) via [Turing](https://github.com/TuringLang/Turing.jl). However, methods can be extended to acommodate other samplers and test models.

## Overview of Features
- Benchmarking Parameters: vary factors such as sample size, data-generating parameters, prior distributions, and target acceptance rate. The use of optional keywords allows other benchmarking parameters to be varied. 
- Plotting: generate and save plots comparing samplers in terms of run time, convergence diagnostics and effective sample size (see below).
- Test Suite: a suite of test models that span a wide range of difficulty. 

## Test Suite 
The table below provides a working list of test models that will be included in the test suite as well as their current development status, ordered approximately from easist to most difficult:  

- [Gaussian Model](https://en.wikipedia.org/wiki/Normal_distribution): simple two parameter Gaussian distribution
- [Signal Detection Model](https://en.wikipedia.org/wiki/Detection_theory): a simple model used in psychophysics and signal processing, which decomposes performance in terms of descriminability and bias
- [Linear Regession Model](https://en.wikipedia.org/wiki/Linear_regression)
- Hierarchical Poisson Regression
- [Linear Ballistic Accumulator](https://s3.amazonaws.com/academia.edu.documents/38243618/The_simplest_complete_model_of_choice_response_time-_Linear_Ballistic_Accumulation.pdf?AWSAccessKeyId=AKIAIWOWYYGZ2Y53UL3A&Expires=1558170639&Signature=DucSUdy%2FFW1jFCZcsN%2FvZbAqsrk%3D&response-content-disposition=inline%3B%20filename%3DThe_simplest_complete_model_of_choice_re.pdf): a cognitive model of perception and simple decision making. 

| Model                           | Author | Turing  | DynamicHMC       | DynamicNUTS               | CmdStan |
|---------------------------------|--------|---------|------------------|---------------------------|---------|
| Gaussian Model                  | Chris  | Working | Working          | Working                   | Working |
| Signal Detection Theory         | Chris  | Working | Errors out       | Hard crash due  to NaN    | Working |
| Linear Regression               | Rob    |         |                  |                           |         |
| Hierarchical Poisson Regression | Rob    |         |                  |                           |         |
| Linear Ballistic Accumulator    | Chris  | Working | Non-finite error | density start point error | Working |

## Preliminary Results

In the links below, you will find preliminary results for a simple Gaussian model. 

[Performance comparison on sample size](https://github.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl/blob/master/Examples/Gaussian/results/Mean%20Time.pdf)

[Performance distribution on sample size](https://github.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl/blob/master/Examples/Gaussian/results/Time%20Dist.pdf)

[Diagnostics comparison of estimated ess values ](https://github.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl/blob/master/Examples/Gaussian/results/Mu%20ESS%20Dist.pdf)

[Diagnostics comparison of rhat estimates ](https://github.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl/blob/master/Examples/Gaussian/results/Mu%20rhat%20Dist.pdf)

[Diagnostics comparison leapfrog stepsizes ](https://github.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl/blob/master/Examples/Gaussian/results/Mu%20Epsilon%20Scatter.pdf)
