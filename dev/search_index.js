var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "#MCMCBenchmarks.jl-Documentation-1",
    "page": "Home",
    "title": "MCMCBenchmarks.jl Documentation",
    "category": "section",
    "text": "A flexible package for benchmarking MCMC samplers in Julia."
},

{
    "location": "#Introduction-1",
    "page": "Home",
    "title": "Introduction",
    "category": "section",
    "text": "Welcome to the documentation for MCMCBenchmarks, a benchmarking package for MCMC samplers written in the Julia language. Below, you will find an overview of features, the outline of the documentation, and an index of functions provided within MCMCBenchmarks. Use the navigation panel to your left to find more detailed information, including a fully annotated example for creating a benchmark, and results from our benchmarking suite.Please report bugs, issues, and feature requests using the GitHub issue tracker. Be sure to describe the nature of the problem and include a minimum working example if possible. We also welcome models to add to the benchmarking suite, which can be submitted via a pull request."
},

{
    "location": "#Features-1",
    "page": "Home",
    "title": "Features",
    "category": "section",
    "text": "Flexible: specify factors to vary in your benchmark, such as number of MCMC samples, MCMC configuration, the size of datasets, and data generating parameters\nParallel: distribute your benchmark over multiple processors to produce efficient benchmarks\nExtendable: use multiple dispatch to benchmark new samplers\nPerformance Metrics: r̂, effective sample size, effective sample size per second, run time, percentage of time in garbage collection, MBs of memory allocated, number of memory allocations.\nPlots: density plots, summary plots, scatter plots, parameter recovery plotsPages = [\n    \"src/index.md\",\n    \"src/purpose.md\",\n    \"src/design.md\",\n    \"src/example.md\",\n    \"src/functions.md\",\n    \"src/benchmarks.md\",\n]\nDepth = 1"
},

{
    "location": "#Index-1",
    "page": "Home",
    "title": "Index",
    "category": "section",
    "text": ""
},

{
    "location": "purpose/#",
    "page": "Purpose",
    "title": "Purpose",
    "category": "page",
    "text": ""
},

{
    "location": "purpose/#Background-1",
    "page": "Purpose",
    "title": "Background",
    "category": "section",
    "text": "Bayesian inference is a flexible and popular statistical framework that is used in numerous fields of science, engineering, and machine learning. The goal of Bayesian inference is to learn about likely parameter values of a model through observed data. The end product of Bayesian inference is a posterior distribution over the parameter space P(Θ|Y), which quantifies uncertainty in the parameter values. Because real-world models do not have analytical solutions for P(Θ|Y), computational methods, such as MCMC sampling algorithms, are used to approximate analytical solutions, and form the basis of Bayesian inference.Given the ubiquity of Bayesian inference, it is important to understand the features and performance of available MCMC sampler packages. MCMCBenchmarks.jl aims to accomplish three goals: (1) help Julia users decide which MCMC samplers to use on the basis of performance, (2) help Julia developers identify performance issues, and (3) provide developers with a flexible framework for benchmarking models and samplers aside from those included in the package."
},

{
    "location": "purpose/#Benchmarking-Challenges-1",
    "page": "Purpose",
    "title": "Benchmarking Challenges",
    "category": "section",
    "text": "One of the most significant challenges with benchmarking MCMC samplers is the lack of uniform interface. Some samplers may require different arguments or configurations because they function differently or are associated with different packages. In addition, models used for benchmarking differ in terms of parameters, data structure, and function arguments. Without a unifying framework, benchmarking MCMC samplers can be cumbersome, resulting one-off scripts and inflexible code. Our goal in developing MCMCBenchmarks was to fulfill this need for a unifying framework."
},

{
    "location": "design/#",
    "page": "Design",
    "title": "Design",
    "category": "page",
    "text": ""
},

{
    "location": "design/#Basic-Design-1",
    "page": "Design",
    "title": "Basic Design",
    "category": "section",
    "text": "MCMCBenchmarks uses a combination of multiple dispatch and optional keyword arguments to satisfy the differing requirements of MCMC samplers and models. Benchmark routines are performed with three primary overloaded functions:modifyConfig: modifies the configuration of the sampler\nrunSampler: passes necessary arguments to sampler and runs the sampler\nupdateResults: adds benchmark performance data to a results DataFrameThese functions are overloaded with sampler-specific methods, ensuring that the requirements for each sampler are satisfied. Additional flexibility is gained through the use of optional keyword arguments. Each method captures relevant keyword arguments and collects irrelevant arguments in kwargs... where they are ignored."
},

{
    "location": "functions/#",
    "page": "Functions",
    "title": "Functions",
    "category": "page",
    "text": ""
},

{
    "location": "functions/#MCMCBenchmarks.MCMCSampler",
    "page": "Functions",
    "title": "MCMCBenchmarks.MCMCSampler",
    "category": "type",
    "text": "Abstract MCMC sampler type\n\n\n\n\n\n"
},

{
    "location": "functions/#MCMCBenchmarks.CmdStanNUTS",
    "page": "Functions",
    "title": "MCMCBenchmarks.CmdStanNUTS",
    "category": "type",
    "text": "MCMC sampler struct for CmdStan NUTS\n\nmodel: model configuration\ndir: probject directory\nid: a unique identifier for each instance of CmdStan in parallel applications\nname: a unique identifer given to each sampler\n\n\n\n\n\n"
},

{
    "location": "functions/#MCMCBenchmarks.AHMCNUTS",
    "page": "Functions",
    "title": "MCMCBenchmarks.AHMCNUTS",
    "category": "type",
    "text": "MCMC sampler struct for AdvancedHMC NUTS\n\nmodel: model function that accepts data\nconfig: sampler configution settings\nname: a unique identifer given to each sampler\n\n\n\n\n\n"
},

{
    "location": "functions/#MCMCBenchmarks.DHMCNUTS",
    "page": "Functions",
    "title": "MCMCBenchmarks.DHMCNUTS",
    "category": "type",
    "text": "MCMC sampler struct for DynamicHMC NUTS\n\nmodel: model function that accepts data\nconfig: sampler configution settings\nname: a unique identifer given to each sampler\n\n\n\n\n\n"
},

{
    "location": "functions/#Sampler-Structs-1",
    "page": "Functions",
    "title": "Sampler Structs",
    "category": "section",
    "text": "Each sampler is associated with a MCMC sampler struct, which is a subtype of MCMCSampler. In MCMCBenchmarks, we define subtypes of MCMCSampler for three popular NUTS MCMC samplers in Julia: CmdStan, AdvancedHMC via Turing, and DynamicHMC.MCMCSamplerCmdStanNUTSAHMCNUTSDHMCNUTS"
},

{
    "location": "functions/#Functions-1",
    "page": "Functions",
    "title": "Functions",
    "category": "section",
    "text": ""
},

{
    "location": "functions/#MCMCBenchmarks.benchmark",
    "page": "Functions",
    "title": "MCMCBenchmarks.benchmark",
    "category": "function",
    "text": "Runs the benchmarking procedure and returns the results\n\nsamplers: a tuple of samplers or a single sampler object\nsimulate: model simulation function with keyword Nd\nNreps: number of times the benchmark is repeated for each factor combination\n\n\n\n\n\n"
},

{
    "location": "functions/#MCMCBenchmarks.pbenchmark",
    "page": "Functions",
    "title": "MCMCBenchmarks.pbenchmark",
    "category": "function",
    "text": "Runs the benchmarking procedure defined in benchmark in parallel and returns the results\n\nsamplers: a tuple of samplers or a single sampler object\nsimulate: model simulation function with keyword Nd\nNreps: number of times the benchmark is repeated for each factor combination\n\n\n\n\n\n"
},

{
    "location": "functions/#MCMCBenchmarks.benchmark!",
    "page": "Functions",
    "title": "MCMCBenchmarks.benchmark!",
    "category": "function",
    "text": "Primary function that performs mcmc benchmark repeatedly on a set of samplers and records the results.\n\n\'sampler\': tuple of sampler objects\nresults: DataFrame containing benchmark results\ncsr̂: cross sampler r̂\nsimulate: data generating function\nNreps: number of repetitions for a given set of simulation parameters. Default = 100\nkwargs: optional keyword arguments that are passed to modifyConfig!, updateResults! and\n\nrunSampler, providing flexibility in benchmark simulations.\n\n\n\n\n\n"
},

{
    "location": "functions/#Top-level-Benchmark-Routines-1",
    "page": "Functions",
    "title": "Top-level Benchmark Routines",
    "category": "section",
    "text": "benchmarkbenchmark!(samplers,results,csr̂,simulate,Nreps,chains;kwargs...)\n\nbenchmark!(sampler::T,results,csr̂,simulate,Nreps,chains;kwargs...) where {T<:MCMCSampler}pbenchmarkpbenchmark(samplers,simulate,Nreps;kwargs...)\nbenchmark!benchmark!(samplers,results,csr̂,simulate,Nreps,chains;kwargs...)"
},

{
    "location": "functions/#MCMCBenchmarks.modifyConfig!",
    "page": "Functions",
    "title": "MCMCBenchmarks.modifyConfig!",
    "category": "function",
    "text": "Modifies MCMC sampler configuration, including number of samples, target acceptance rate and others depending on the specific sampler.\n\ns: sampler object\nNsamples: total number of MCMC samples\nNadapt: number of adaption samples during warm up\ndelta: target acceptance rate.\n\n\n\n\n\n"
},

{
    "location": "functions/#MCMCBenchmarks.updateResults!",
    "page": "Functions",
    "title": "MCMCBenchmarks.updateResults!",
    "category": "function",
    "text": "Update the results DataFrame on each iteration\n\ns: MCMC sampler object\nperformance: includes MCMC Chain, execution time, and memory measurements\nresults: DataFrame containing benchmark results\n\n\n\n\n\n"
},

{
    "location": "functions/#MCMCBenchmarks.runSampler",
    "page": "Functions",
    "title": "MCMCBenchmarks.runSampler",
    "category": "function",
    "text": "Extracts model and configuration from sampler object and performs parameter estimation\n\ns: sampler object\ndata: data for benchmarking\nNchains: number of chains ran serially. Default =  1\n\n\n\n\n\n"
},

{
    "location": "functions/#Overloaded-Benchmark-Functions-1",
    "page": "Functions",
    "title": "Overloaded Benchmark Functions",
    "category": "section",
    "text": "modifyConfig!modifyConfig!(s::AHMCNUTS;Nsamples,Nadapt,delta,kwargs...)updateResults!updateResults!(s::CmdStanNUTS,performance,results;kwargs...)runSampler runSampler(s::AHMCNUTS,data;kwargs...)\n ```\n\n### Helper Functions\n@docs addPerformance!julia addPerformance!(df,p)@docs addKW!julia addKW!(df;kwargs...)@docs addChainSummary!julia addChainSummary!(newDF,chn,df,col)@docs addHPD!julia addHPD!(newDF,chain)@docs addMeans!julia addMeans!(newDF,df)### Plotting\n@docs plotdensityjulia plotdensity(df::DataFrame,metric::Symbol,group=(:sampler,);save=false,     figfmt=\"pdf\",dir=\"\",options...)@docs plotsummaryjulia plotsummary(df::DataFrame,xvar::Symbol,metric::Symbol,group=(:sampler,);save=false,     figfmt=\"pdf\",func=mean,dir=\"\",options...)@docs plotscatterjulia plotscatter(df::DataFrame,xvar::Symbol,metric::Symbol,group=(:sampler,);save=false,     figfmt=\"pdf\",func=mean,dir=\"\",options...)@docs plotrecoveryjulia plotrecovery(df::DataFrame,parms,group=(:sampler,);save=false,     figfmt=\"pdf\",dir=\"\",options...) ```"
},

{
    "location": "example/#",
    "page": "Example",
    "title": "Example",
    "category": "page",
    "text": ""
},

{
    "location": "example/#Example-1",
    "page": "Example",
    "title": "Example",
    "category": "section",
    "text": ""
},

{
    "location": "example/#Model-1",
    "page": "Example",
    "title": "Model",
    "category": "section",
    "text": "In this detailed example, we will guide users through the process of developing a benchmark within MCMCBenchmarks. To make matters as simple as possible, we will benchmark CmdnStan, AdvancedHMC, and DynamicHMC with a simple Gaussian model. Assume that a vector of observations Y follows a Gaussian distribution with parameters μ and σ, which have Gaussian and Truncated Cauchy prior distributions, respectively. Formally, the Gaussian model is defined as follows:mu sim Normal(01)sigma sim TCauchy(050infty)Y sim Normal(musigma)"
},

{
    "location": "example/#Benchmark-Design-1",
    "page": "Example",
    "title": "Benchmark Design",
    "category": "section",
    "text": "In this example, we will generate data from a Gaussian distribution with parameters μ = 0 and σ = 1 for three sample sizes Nd = [10, 100, 1000]. Each sampler will run for Nsamples = 2000 iterations, Nadapt = 1000 of which are adaption or warmup iterations. The target acceptance rate is set to delta = .8. The benchmark will be repeated 50 times with a different sample of simulated data to ensure that the results are robust across datasets. This will result in 450 benchmarks, (3 (samplers) X 3 (sample sizes) X 50 (repetitions))."
},

{
    "location": "example/#Code-Structure-1",
    "page": "Example",
    "title": "Code Structure",
    "category": "section",
    "text": "In order to perform a benchmark, the user must define the following:A top-level script for calling the necessary functions and specifying the benchmark design. The corresponding code can be found in MCMCBenchmarks/Examples/Gaussian/Gaussian_Example.jl.\nModels defined for each of the samplers with a common naming scheme for parameters. The corresponding code can be found in MCMCBenchmarks/Models/Gaussian/Gaussian_Models.jl.\nSampler specific struct and methods defined for updateResults!, modifyConfig!, and runSampler. Structs and methods for NUTS in CmdStan, AdvancedHMC/Turing, and DynamicHMC are provided by MCMCBenchmarks.We will walk through the code in the top-level script named Gaussian_Example.jl. In the first snippet, we call the required packages, set the number of chains to 4, set the file directory as the project directory, remove old the old CmdStan output director tmp and create a new one, then create a results folder if one does not already exist.  using Revise,MCMCBenchmarks,Distributed\nNchains=4\nsetprocs(Nchains)\n\nProjDir = @__DIR__\ncd(ProjDir)\n\nisdir(\"tmp\") && rm(\"tmp\", recursive=true)\nmkdir(\"tmp\")\n!isdir(\"results\") && mkdir(\"results\")In the following code snippet, we set the path to the Gaussian model file and load them on each of the workers. Next, we suppress the printing of Turing\'s progress and set a seed on each worker.path = pathof(MCMCBenchmarks)\n@everywhere begin\n  using MCMCBenchmarks,Revise\n  #Model and configuration patterns for each sampler are located in a\n  #seperate model file.\n  include(joinpath($path, \"../../Models/Gaussian/Gaussian_Models.jl\"))\nend\n\n#run this on primary processor to create tmp folder\ninclude(joinpath(path,\n  \"../../Models/Gaussian/Gaussian_Models.jl\"))\n\n@everywhere Turing.turnprogress(false)\n#set seeds on each processor\nseeds = (939388,39884,28484,495858,544443)\nfor (i,seed) in enumerate(seeds)\n    @fetch @spawnat i Random.seed!(seed)\nendThe follow snippet creates a tuple of samplers and initializes a CmdStan output folder for each worker.#create a sampler object or a tuple of sampler objects\nsamplers=(\n  CmdStanNUTS(CmdStanConfig,ProjDir),\n  AHMCNUTS(AHMCGaussian,AHMCconfig),\n  DHMCNUTS(sampleDHMC,2000))\n\nstanSampler = CmdStanNUTS(CmdStanConfig,ProjDir)\n#Initialize model files for each instance of stan\ninitStan(stanSampler)At this point, we can define the benchmark design. The design configuration is collected in the NamedTuple called options. MCMCBenchmarks will perform Nrep = 50 repetitions for each combinations of factors defined in options. The number of combinations is computed as: prod(length.(values(options))). In this example, there are three combinations:(Nsamples=2000,Nadapt=1000,delta=.8,Nd=10)\n(Nsamples=2000,Nadapt=1000,delta=.8,Nd=100)\n(Nsamples=2000,Nadapt=1000,delta=.8,Nd=1000)If we set delta = [.65, .80] instead of delta = .80, there would be 6 combinations.#Number of data points\nNd = [10, 100, 1000]\n\n#Number of simulations\nNreps = 50\n\noptions = (Nsamples=2000,Nadapt=1000,delta=.8,Nd=Nd)The function pbenchmark performs the benchmarks in parallel, by dividing the jobs across the available processors. pbenchmark accepts the tuple of samplers, the data generating function, the number of repetitions, and the design options. Upon completion, a DataFrame containing the benchmarks and configuration information is returned.#perform the benchmark\nresults = pbenchmark(samplers,simulateGaussian,Nreps;options...)After the benchmark has completed, the results are saved in the results as a csv file. In addition, relevant package version information and system information is saved in a seperate csv file.#save results\nsave(results,ProjDir)"
},

{
    "location": "example/#Results-Output-1",
    "page": "Example",
    "title": "Results Output",
    "category": "section",
    "text": "The following information is stored in the results DataFrame:Each parameter is associated with a column for each of the following performance metrics: Effective Sample Size, Effective Sample Size per second, cross-sampler r̂\nA column for each of following performance metrics: run time, % garbage collection time, number of memory allocations, the amount of memory allocated in MB\nA column for sampler specific quantities: epsilon (step size) and tree depth\nA sampler name column\nThe column for each design element in the benchmark design NamedTupleHere is an example of the results output:\n450×26 DataFrames.DataFrame\n│ Row │ mu_ess  │ mu_ess_ps │ mu_hdp_lb   │ mu_hdp_ub    │ mu_mean      │ mu_r_hat │ sigma_ess │ sigma_ess_ps │ sigma_hdp_lb │ sigma_hdp_ub │ sigma_mean │ sigma_r_hat │ epsilon  │ tree_depth │ time      │ megabytes │ gctime     │ gcpercent  │ allocations │ sampler     │ Nsamples │ Nadapt │ delta   │ Nd    │ mu_sampler_rhat │ sigma_sampler_rhat │\n│     │ Float64 │ Float64   │ Float64     │ Float64      │ Float64      │ Float64  │ Float64   │ Float64      │ Float64      │ Float64      │ Float64    │ Float64     │ Float64  │ Float64    │ Float64   │ Float64   │ Float64    │ Float64    │ Int64       │ String      │ Int64    │ Int64  │ Float64 │ Int64 │ Float64         │ Float64            │\n├─────┼─────────┼───────────┼─────────────┼──────────────┼──────────────┼──────────┼───────────┼──────────────┼──────────────┼──────────────┼────────────┼─────────────┼──────────┼────────────┼───────────┼───────────┼────────────┼────────────┼─────────────┼─────────────┼──────────┼────────┼─────────┼───────┼─────────────────┼────────────────────┤\n│ 1   │ 453.183 │ 1101.93   │ -0.439951   │ 1.01233      │ 0.335121     │ 1.01192  │ 561.67    │ 1365.72      │ 0.694345     │ 1.85464      │ 1.20432    │ 0.999773    │ 0.769406 │ 2.113      │ 0.411262  │ 7.78675   │ 0.0        │ 0.0        │ 175314      │ CmdStanNUTS │ 2000     │ 1000   │ 0.8     │ 10    │ 1.00571         │ 1.00186            │\n│ 2   │ 439.956 │ 1197.47   │ -0.345675   │ 1.05657      │ 0.29728      │ 1.01183  │ 349.387   │ 950.962      │ 0.680205     │ 1.96625      │ 1.2538     │ 0.999099    │ 0.706563 │ 2.219      │ 0.367404  │ 233.422   │ 0.0741201  │ 0.20174    │ 2654525     │ AHMCNUTS    │ 2000     │ 1000   │ 0.8     │ 10    │ 1.00571         │ 1.00186            │\n│ 3   │ 750.97  │ 6877.37   │ -0.418789   │ 0.98444      │ 0.315015     │ 1.00147  │ 436.824   │ 4000.43      │ 0.685377     │ 1.88949      │ 1.20968    │ 1.00001     │ 0.793221 │ 1.915      │ 0.109194  │ 58.6358   │ 0.0288007  │ 0.263756   │ 1530417     │ DHMCNUTS    │ 2000     │ 1000   │ 0.8     │ 10    │ 1.00571         │ 1.00186            │\n│ 4   │ 627.599 │ 1585.39   │ -0.465991   │ 0.419506     │ -0.0264066   │ 1.00156  │ 687.419   │ 1736.51      │ 0.41708      │ 1.11226      │ 0.723098   │ 1.0025      │ 0.853159 │ 1.842      │ 0.395863  │ 7.26259   │ 0.0        │ 0.0        │ 165981      │ CmdStanNUTS │ 2000     │ 1000   │ 0.8     │ 10    │ 0.999527        │ 1.00135            │\n│ 5   │ 310.065 │ 762.221   │ -0.48833    │ 0.46412      │ -0.0270623   │ 0.999198 │ 375.669   │ 923.491      │ 0.354449     │ 1.16472      │ 0.747474   │ 0.99918     │ 0.718885 │ 2.269      │ 0.406792  │ 236.96    │ 0.0790683  │ 0.19437    │ 2731926     │ AHMCNUTS    │ 2000     │ 1000   │ 0.8     │ 10    │ 0.999527        │ 1.00135            │\n│ 6   │ 627.462 │ 4769.92   │ -0.516661   │ 0.409657     │ -0.0253033   │ 0.999118 │ 388.73    │ 2955.1       │ 0.406456     │ 1.11744      │ 0.743553   │ 0.999008    │ 0.429143 │ 2.317      │ 0.131546  │ 71.1897   │ 0.0312859  │ 0.237833   │ 1877320     │ DHMCNUTS    │ 2000     │ 1000   │ 0.8     │ 10    │ 0.999527        │ 1.00135            │\n│ 7   │ 635.731 │ 1587.98   │ -0.271512   │ 0.854006     │ 0.275059     │ 1.0016   │ 576.698   │ 1440.52      │ 0.537828     │ 1.43556      │ 0.953825   │ 0.999986    │ 0.779473 │ 1.906      │ 0.400339  │ 7.25304   │ 0.0        │ 0.0        │ 165982      │ CmdStanNUTS │ 2000     │ 1000   │ 0.8     │ 10    │ 0.999831        │ 1.00377            │"
},

{
    "location": "benchmarks/#",
    "page": "Benchmark Results",
    "title": "Benchmark Results",
    "category": "page",
    "text": ""
},

{
    "location": "benchmarks/#Benchmark-Results-1",
    "page": "Benchmark Results",
    "title": "Benchmark Results",
    "category": "section",
    "text": "In this section, we report key benchmark results comparing Turing, CmdStan, and DynamicHMC for a variety of models. The code for each of the benchmarks can be found in the Examples folder, while the corresponding code for the models in folder named Models. The benchmarks were performed with the following software and hardware:Julia 1.2.0\nCmdStan 5.2.0\nTuring 0.7.0\nAdvancedHMC 0.2.6\nDynamicHMC 2.1.0\nUbuntu 18.04\nIntel(R) Core(TM) i7-4790K CPU @ 4.00GHzBefore proceeding to the results, a few caveats should be noted. (1) Turing\'s performance may improve over time as it matures. (2) memory allocations and garbage collection time are not applicable for CmdStan because the heavy lifting is performed in C++ where it is not measured. (3) Compared to Stan, Turing and DynamicHMC exhibit poor scalability in large part due to the use of forward mode autodiff. As soon as the reverse mode autodiff package Zygote matures in Julia, it will become the default autodiff in MCMCBenchmarks."
},

{
    "location": "benchmarks/#Gaussian-1",
    "page": "Benchmark Results",
    "title": "Gaussian",
    "category": "section",
    "text": "Modelmu sim Normal(01)sigma sim TCauchy(050infty)Y sim Normal(musigma)benchmark design#Number of data points\nNd = [10, 100, 1000, 10_000]\n#Number of simulations\nNreps = 50\noptions = (Nsamples=2000, Nadapt=1000, delta=.8, Nd=Nd)speed<img src=\"images/Gaussian/summary_time.png\" width=\"500\"/>allocations<img src=\"images/Gaussian/summary_allocations.png\" width=\"500\"/>effective sample size<img src=\"images/Gaussian/density_mu_ess.png\" width=\"700\"/>"
},

{
    "location": "benchmarks/#Signal-Detection-Theory-1",
    "page": "Benchmark Results",
    "title": "Signal Detection Theory",
    "category": "section",
    "text": "Modeld sim Normal(01sqrt(5))c sim Normal(01sqrt(2))theta_hits = ϕ(d2-c)theta_fas = ϕ(-d2-c)n_hits sim Binomial(Ntheta_hits)n_fas sim Binomial(Ntheta_fas)benchmark design#Number of data points\nNd = [10, 100, 1000, 10_000]\n#Number of simulations\nNreps = 100\noptions = (Nsamples=2000, Nadapt=1000, delta=.8, Nd=Nd)\n#perform the benchmarkspeed<img src=\"images/SDT/summary_time.png\" width=\"500\"/>allocations<img src=\"images/SDT/summary_allocations.png\" width=\"500\"/>effective sample size<img src=\"images/SDT/density_d_ess.png\" width=\"700\"/>"
},

{
    "location": "benchmarks/#Linear-Regression-1",
    "page": "Benchmark Results",
    "title": "Linear Regression",
    "category": "section",
    "text": "Modelbeta_0 sim Normal(010)boldsymbolbeta sim Normal(010)sigma sim TCauchy(050infty)mu = beta_0 + boldsymbolXboldsymbolbetaY sim Normal(musigma)benchmark design#Number of data points\nNd = [10, 100, 1000]\n#Number of coefficients\nNc = [2, 3]\n#Number of simulations\nNreps = 50\noptions = (Nsamples=2000, Nadapt=1000, delta=.8, Nd=Nd, Nc=Nc)speed<img src=\"images/Linear_Regression/summary_time.png\" width=\"700\"/>allocations<img src=\"images/Linear_Regression/summary_allocations.png\" width=\"700\"/>effective sample size<img src=\"images/Linear_Regression/summary_B0_ess.png\" width=\"700\"/>"
},

{
    "location": "benchmarks/#Linear-Ballistic-Accumulator-(LBA)-1",
    "page": "Benchmark Results",
    "title": "Linear Ballistic Accumulator (LBA)",
    "category": "section",
    "text": "Modeltau sim TNormal(410y_min)A sim TNormal(840infty)k sim TNormal(230infty)v sim Normal(03)(tc) sim LBA(Abvstau)wheret = y_i - t_erb = A + ks = 1LBA(Abvstau) = f_c(t)prod_j neq c (1-F_j(t))f_c(t) = frac1A left-v_c Phileft( fracb-A-tv_cts right) + phileft( fracb-A-tv_cts right) +\n+ v_c Phileft( fracb-tv_cts right) + s phileft( fracb-tv_cts right) rightbeginmultline*\n F_c(t) = 1 + fracb-A-tv_cA Phileft( fracb-A-tv_cts right) - fracb-tv_cA Phileft( fracb-tv_cts right)\n + fractsA phileft( fracb-A-tv_cts right) - fractsA phileft( fracb-tv_cts right)\n endmultline*Y = y_1y_ny_min = minimum(Y)benchmark design#Number of data points\nNd = [10, 50, 200]\n#Number of simulations\nNreps = 50\noptions = (Nsamples=2000, Nadapt=1000, delta=.8, Nd=Nd)speed<img src=\"images/LBA/summary_time.png\" width=\"500\"/>allocations<img src=\"images/LBA/summary_allocations.png\" width=\"500\"/>effective sample size<img src=\"images/LBA/density_A_ess.png\" width=\"700\"/>"
},

{
    "location": "benchmarks/#Poisson-Regression-1",
    "page": "Benchmark Results",
    "title": "Poisson Regression",
    "category": "section",
    "text": "Modela_0 sim Normal(010)a_1 sim Normal(01)sigma_a0 sim TCauchy(010infty)a_0i  sim Normal(0sigma_a0)lambda = e^a_0 + a_0i + a_1*x_iy_i sim Poisson(lambda)benchmark design# Number of data points per unit\nNd = [1, 2, 5]\n# Number of units in model\nNs = 10\n# Number of simulations\nNreps = 25\noptions = (Nsamples=2000, Nadapt=1000, delta=.8, Nd=Nd, Ns=Ns)\nspeed<img src=\"images/Hierarchical_Poisson/summary_time.png\" width=\"500\"/>allocations<img src=\"images/Hierarchical_Poisson/summary_allocations.png\" width=\"500\"/>effective sample size<img src=\"images/Hierarchical_Poisson/density_a0_ess.png\" width=\"500\"/>"
},

{
    "location": "benchmarks/#Forward-vs.-Reverse-Autodiff-1",
    "page": "Benchmark Results",
    "title": "Forward vs. Reverse Autodiff",
    "category": "section",
    "text": "Hierarchical Poisson\nbenchmark design\n# Number of data points per unit\nNd = 1\n# Number of units in model\nNs = [10, 20, 50]\n# Number of simulations\nNreps = 20\nautodiff = [:forward, :reverse]\noptions = (Nsamples=2000, Nadapt=1000, delta=.8, Nd=Nd, Ns=Ns, autodiff=autodiff)\nspeed<img src=\"images/Autodiff/summary_time.png\" width=\"500\"/>allocations<img src=\"images/Autodiff/summary_allocations.png\" width=\"500\"/>effective sample size<img src=\"images/Autodiff/density_a0_ess.png\" width=\"700\"/>"
},

]}
