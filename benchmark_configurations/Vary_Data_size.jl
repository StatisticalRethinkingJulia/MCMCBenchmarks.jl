using Distributed
"""
Runs the benchmarking procedure and returns the results

* `samplers`: a tuple of samplers or a single sampler object
* `simulate`: model simulation function with keyword Nd
* `Nreps`: number of times the benchmark is repeated for each factor combination
"""
 function benchmark(samplers,simulate,Nd,Nreps=100)
     results = DataFrame()
     for nd in Nd
       benchmark!(samplers,results,simulate,Nreps;Nd=nd,Nsamples=2000,Nadapt=1000,delta=.8)
     end
     return results
 end

 """
 Runs the benchmarking procedure defined in benchmark in parallel and returns the results

 * `samplers`: a tuple of samplers or a single sampler object
 * `simulate`: model simulation function with keyword Nd
 * `Nreps`: number of times the benchmark is repeated for each factor combination
 """
 function pbenchmark(samplers,simulate,Nd,Nreps=100)
     pfun(rep) = benchmark(samplers,simulate,Nd,rep)
     reps = setreps(Nreps)
     presults = pmap(rep->pfun(rep),reps)
     return vcat(presults...)
 end

 """
 Sets seeds on primary and secondary processors
 """
 function setSeeds!(seeds...)
     for (i,seed) in enumerate(seeds)
         @fetch @spawnat i Random.seed!(seed)
     end
 end
