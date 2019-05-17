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

This package will contain performance and diagnostics comparisons between CmdStan, DynamicHMC, AdvancedHMC and/or Turing/NUTS.

Initial examples of the types of results are:

[Performance comparison on sample size](https://github.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl/blob/master/Examples/Gaussian/Mean%20Time.pdf)

[Performance distribution on sample size](https://github.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl/blob/master/Examples/Gaussian/Time%20Dist.pdf)

[Diagnostics comparison of estimated ess values ](https://github.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl/blob/master/Examples/Gaussian/Mu%20ESS%20Dist.pdf)

[Diagnostics comparison of rhat estimates ](https://github.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl/blob/master/Examples/Gaussian/Mu%20rhat%20Dist.pdf)

[Diagnostics comparison leapfrog stepsizes ](https://github.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl/blob/master/Examples/Gaussian/Mu%20Epsilon%20Scatter.pdf)
