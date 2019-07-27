# MCMCBenchmarks.jl Documentation


```@contents
```

## Purpose

Bayesian inference is a flexible and popular statistical framework that is used in numerous fields of science, engineering, and machine learning. The goal of Bayesian inference is to learn about likely parameter values of a model through observed data. The end product of Bayesian inference is a posterior distribution P(Θ|Y) over the parameter space, which quantifies uncertainty in the parameter values. Because real-world models do not have analytical solutions for P(Θ|Y), computational methods, such as MCMC sampling algorithms, are used to approximate analytical solutions, and form the basis of Bayesian inference.

Given the ubiquity of Bayesian inference, it is important to understand the features and performance of available MCMC sampler packages. MCMCBenchmarks.jl aims to accomplish three goals: (1) help Julia users decide which MCMC samplers to use on the basis of performance, (2) help Julia developers identify performance issues, and (3) provide a flexible framework for benchmarking models and samplers aside from those included in the package.

## Benchmarking Challenges

One of the challenges with benchmarking MCMC samplers is the lack of uniform interface. Some samplers may require different arguments or configurations because they function differently or are associated with different packages. In addition, models used for benchmarking differ in terms of parameters, data structure, and function arguments. Without a unifying framework, benchmarking MCMC samplers can be cumbersome, resulting one-off scripts and inflexible code. Our goal in developing MCMCBenchmarks was to fulfill the need for a unifying framework.

## Basic Design

MCMCBenchmarks uses a combination of multiple dispatch and optional keyword arguments to satisfy the differing requirements of MCMC samplers and models. Benchmark routines are performed with three primary overloaded functions:

* `runSampler`: passes necessary arguments to sampler and runs the sampler

* `updateResults`: adds benchmark performance data to a results `DataFrame`

* `modifyConfig`: modifies the configuration of the sampler

These functions are overloaded with sampler-specific methods, ensuring that the requirements for each sampler are satisfied. Additional flexibility is gained through the use of optional keyword arguments. Each method captures relevant keyword arguments and collects irrelevant arguments in `kwargs...` where they are ignored.

## Features

* Flexible: specify factors to vary in your benchmark, such as number of MCMC samples, MCMC configuration, the size of datasets, and data generating parameters
* Parallel: distribute your benchmark over multiple processors to produce efficient benchmarks
* Extendable: use multiple dispatch to benchmark new samplers
* Performance Metrics: r̂,effective sample size, effective sample size per second, run time, percentage of time in garbage collection, MBs of memory allocated, number of memory allocations.
* Plots: density plots, summary plots, scatter plots, parameter recovery plots

## Index

```@index
```
