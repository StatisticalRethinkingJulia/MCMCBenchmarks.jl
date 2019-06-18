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

MCMCBenchmarks (WIP) provides a lightweight yet flexible framework for benchmarking MCMC samplers in terms of runtime, memory usage, convergence metrics and effective sample size. Currently, MCMCBenchmarks provides out of the box support for benchmarking the [No-U-Turn Sampler](http://jmlr.org/papers/volume15/hoffman14a/hoffman14a.pdf) (NUTS) algorithm as implemented in [CmdStan](https://github.com/StanJulia/CmdStan.jl), [DynamicHMC](https://github.com/tpapp/DynamicHMC.jl) and [AdvancedHMC](https://github.com/TuringLang/AdvancedHMC.jl) via [Turing](https://github.com/TuringLang/Turing.jl). However, methods can be extended to acommodate other samplers and test models.

## Overview of Features
- Benchmarking Parameters: vary factors such as sample size, data-generating parameters, prior distributions, and target acceptance rate. The use of optional keywords allows other benchmarking parameters to be varied. 
- Plotting: generate and save plots comparing samplers in terms of run time, memory usage, convergence diagnostics and effective sample size (see below).
- Test Suite: a suite of test models that span a wide range of difficulty. 

## Test Suite 
The table below provides a working list of test models that will be included in the test suite as well as their current development status, ordered approximately from easist to most difficult:  

- [Gaussian Model](https://en.wikipedia.org/wiki/Normal_distribution): simple two parameter Gaussian distribution
- [Signal Detection Model](https://en.wikipedia.org/wiki/Detection_theory): a simple model used in psychophysics and signal processing, which decomposes performance in terms of descriminability and bias
- [Linear Regession Model](https://en.wikipedia.org/wiki/Linear_regression)
- Hierarchical Poisson Regression
- [Linear Ballistic Accumulator](https://s3.amazonaws.com/academia.edu.documents/38243618/The_simplest_complete_model_of_choice_response_time-_Linear_Ballistic_Accumulation.pdf?AWSAccessKeyId=AKIAIWOWYYGZ2Y53UL3A&Expires=1558170639&Signature=DucSUdy%2FFW1jFCZcsN%2FvZbAqsrk%3D&response-content-disposition=inline%3B%20filename%3DThe_simplest_complete_model_of_choice_re.pdf): a cognitive model of perception and simple decision making. 

| Model                           	| Turing  	| DynamicHMC 	| DynamicNUTS               	| CmdStan 	|
|---------------------------------	|---------	|------------	|---------------------------	|---------	|
| Gaussian Model                  	| Working 	| Working    	| Working                   	| Working 	|
| Signal Detection Theory         	| Working 	| Working    	| Hard crash due  to NaN    	| Working 	|
| Linear Regression               	| Working 	| Working    	| Not Working               	| Working 	|
| Hierarchical Poisson Regression 	|         	|            	|                           	|         	|
| Linear Ballistic Accumulator    	| Working 	| Working    	| density start point error 	| Working 	|

## Preliminary Results

Below, we report preliminary benchmark results, comparing CmdStan, DynamicHMC and AdvancedHMC/Turing using the Gaussian Model. In the benchmark, we varied the data sample size (Nd) across the values 10, 100 and 1,000 and repeated the benchmark 100 times.  

[Comparison of run time](https://github.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl/blob/master/Examples/Gaussian/results/summary_time.pdf)

[Comparison of memory allocations](https://github.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl/blob/master/Examples/Gaussian/results/summary_allocations.pdf)

[Comparison of effective sample size distribution](https://github.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl/blob/master/Examples/Gaussian/results/density_mu_ess.pdf)

[Comparison of r_hat distribution](https://github.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl/blob/master/Examples/Gaussian/results/density_mu_r_hat.pdf)

[Relationship between effective sample size and epsilon](https://github.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl/blob/master/Examples/Gaussian/results/scatter_epsilon_mu_ess.pdf)
