## Basic Design

MCMCBenchmarks uses a combination of multiple dispatch and optional keyword arguments to satisfy the differing requirements of MCMC samplers and models. Benchmark routines are performed with three primary overloaded functions:

* `modifyConfig`: modifies the configuration of the sampler

* `runSampler`: passes necessary arguments to sampler and runs the sampler

* `updateResults`: adds benchmark performance data to a results `DataFrame`

These functions are overloaded with sampler-specific methods, ensuring that the requirements for each sampler are satisfied. Additional flexibility is gained through the use of optional keyword arguments. Each method captures relevant keyword arguments and collects irrelevant arguments in `kwargs...` where they are ignored.
