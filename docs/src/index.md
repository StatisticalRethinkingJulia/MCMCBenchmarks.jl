# MCMCBenchmarks.jl Documentation


```@contents
```

## Purpose

Bayesian inference is a flexible and popular statistical framework that is used in numerous fields of science, engineering, and machine learning. The goal of Bayesian inference is to learn about likely parameter values of a model through observed data. The end product of Bayesian inference is a posterior distribution P(Θ|Y) over the parameter space, which quantifies uncertainty in the parameter values. Because real-world models do not have analytical solutions for P(Θ|Y), computational methods, such as MCMC sampling algorithms, are used to approximate analytical solutions, and form the basis of Bayesian inference.

Given the ubiquity of Bayesian inference, it is important to understand the features and performance of available MCMC sampler packages.  MCMCBenchmarks.jl aims to accomplish three goals: (1) help Julia users decide which MCMC samplers to use on the basis of performance, (2) help Julia developers identify performance issues, and (3) provide a flexible framework for benchmarking models and samplers aside from those included in the package.

## Benchmarking Challenges

One of the challenges with benchmarking MCMC samplers is the lack of uniform interface. Some samplers may require different arguments or configurations because they function differently or are associated with different packages. In addition, models used for benchmarking differ in terms of parameters, data structure, and function arguments. Without a unifying framework, benchmarking MCMC samplers can be cumbersome, resulting one-off scripts and inflexible code. Our goal in developing MCMCBenchmarks was to fulfill the need for a unifying framework.

## Basic Design

MCMCBenchmarks uses a combination of multiple dispatch and optional keyword arguments to satisfy the differing requirements of MCMC samplers and models. Benchmark routines are performed with three primary overloaded functions:

* runSampler: passes necessary arguments to sampler and runs the sampler

* updateResults: adds benchmark performance data to a results DataFrame

* modifyConfig: modifies the configuration of the sampler

These functions are overloaded with sampler-specific methods, ensuring that the requirements for each sampler are satisfied. Additional flexibility is gained through the use of optional keyword arguments. Each method captures relevant keyword arguments and collects irrelevant arguments in "kwargs..." where they are ignored.

## Features

## Example

### Model

In this detailed example, we will guide users through the process of developing a benchmark within MCMCBenchmarks. To make matters as simple as possible, we will benchmark CmdnStan, AdvancedHMC, and DynamicHMC with a simple Gaussian model. Assume that a vector of observations Y follows a Gaussian distribution with parameters μ and σ, which have Gaussian and Truncated Cauchy prior distributions, respectively. Formally, the Gaussian model is defined as follows:

"""
\\mu ~ Normal(0,1)
\\sigma ~ TCauchy(0,5,0,\infty)
\Y ~ Normal(\mu,\sigma)
"""
### Benchmark Design

In this example, we will generate data from a Gaussian distribution with parameters μ = 0 and σ = 1 for three sample sizes Nd = [10, 100, 1000]. Each sampler will run for Nsamples = 2000 iterations, Nadapt = 1000 of which are adaption or warmup iterations. The target acceptance rate is set to delta = .8. The benchmark will be repeated 50 times with a different sample of simulated data to ensure that the results are robust across datasets. This will result in 450 benchmarks, (3 (samplers) X 3 (sample sizes) X 50 (repetitions)).

### Code Structure

In order to perform a benchmark, the user must define the following:

* A top-level script for calling the necessary functions and specifying the benchmark design. The corresponding code can be found in MCMCBenchmarks/Examples/Gaussian/Gaussian_Example.jl.

* Models defined for each of the samplers with a common naming scheme for parameters. The corresponding code can be found in MCMCBenchmarks/Models/Gaussian/Gaussian_Models.jl.

* Sampler specific struct and methods defined for updateResults!, modifyConfig!, and runSampler. Structs and methods for NUTS in CmdStan, AdvancedHMC/Turing, and DynamicHMC are provided by MCMCBenchmarks.



### Output  

## Results DataFrame

## Benchmark Results

## Sampler Structs

Each sampler is associated with a MCMC sampler struct, which is a subtype of MCMCSampler. In MCMCBenchmarks, we define subtypes of MCMCSampler for three popular NUTS MCMC samplers in Julia: CmdStan (hyperlink), AdvancedHMC via Turing (hyperlink), and DynamicHMC (hyperlink).

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

## Index

```@index
```
