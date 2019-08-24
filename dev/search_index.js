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
    "location": "#Features-1",
    "page": "Home",
    "title": "Features",
    "category": "section",
    "text": "Flexible: specify factors to vary in your benchmark, such as number of MCMC samples, MCMC configuration, the size of datasets, and data generating parameters\nParallel: distribute your benchmark over multiple processors to produce efficient benchmarks\nExtendable: use multiple dispatch to benchmark new samplers\nPerformance Metrics: r̂,effective sample size, effective sample size per second, run time, percentage of time in garbage collection, MBs of memory allocated, number of memory allocations.\nPlots: density plots, summary plots, scatter plots, parameter recovery plotsPages = [\n    \"src/purpose.md\",\n    \"src/design.md\",\n    \"src/example.md\",\n    \"src/functions.md\",\n    \"src/benchmarks.md\",\n]\nDepth = 1\n\n\n## Index\n@index ```"
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
    "text": "MCMCBenchmarks uses a combination of multiple dispatch and optional keyword arguments to satisfy the differing requirements of MCMC samplers and models. Benchmark routines are performed with three primary overloaded functions:runSampler: passes necessary arguments to sampler and runs the sampler\nupdateResults: adds benchmark performance data to a results DataFrame\nmodifyConfig: modifies the configuration of the samplerThese functions are overloaded with sampler-specific methods, ensuring that the requirements for each sampler are satisfied. Additional flexibility is gained through the use of optional keyword arguments. Each method captures relevant keyword arguments and collects irrelevant arguments in kwargs... where they are ignored."
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
    "text": "The following information is stored in the results DataFrame:Each parameter is associated with a column for each of the following quantities: Effective Sample Size, Effective Sample Size per second, cross-sampler r̂\nA sampler name column\nThe column for each design element in the options NamedTuple\nA column for each of following performance metrics: run time, % garbage collection time, number of memory allocations, the amount of memory allocated in MB"
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
    "text": "In this section, we report key benchmark results comparing Turing, CmdStan, and DynamicHMC for a variety of models. The code for each of the benchmarks can be found in the Examples folder, including corresponding code for the models in folder named Models. The benchmarks were performed with the following software and hardware:Julia 1.1.1\nCmdStan 5.1.1\nTuring 0.6.23\nDynamicHMC 1.0.6\nUbuntu 18.04\nIntel(R) Core(TM) i7-4790K CPU @ 4.00GHzBefore proceeding to the results, a few caveates should be noted. (1) Turing and DynamicHMC are under active development. Consequentially, their performance may improve over time. (2) Memory allocations and garbage collection time is not applicable for CmdStan because the heavy lifting is performed in C++. (3) Performance scaling is poor for Turing and DynamicHMC because they use forward mode autodifferentiation where as CmdStan uses reverse mode autodifferentiation."
},

{
    "location": "benchmarks/#Gaussian-1",
    "page": "Benchmark Results",
    "title": "Gaussian",
    "category": "section",
    "text": "Modelmu sim Normal(01)sigma sim TCauchy(050infty)Y sim Normal(musigma)benchmark design#Number of data points\nNd = [10, 100, 1000]\n#Number of simulations\nNreps = 50\noptions = (Nsamples=2000,Nadapt=1000,delta=.8,Nd=Nd)speed(Image: Gaussian_Speed)allocations(Image: Gaussian_Allocations)effective sample size(Image: Gaussian_MuESS)(Image: Gaussian_SigmaESS)"
},

{
    "location": "benchmarks/#Signal-Detection-Theory-1",
    "page": "Benchmark Results",
    "title": "Signal Detection Theory",
    "category": "section",
    "text": "Modeld sim Normal(01sqrt(2))c sim Normal(01sqrt(2))theta_hits = ϕ(d2-c)theta_fas = ϕ(-d2-c)n_hits sim Binomial(Ntheta_hits)n_fas sim Binomial(Ntheta_fas)benchmark design#Number of data points\nNd = [10,100,1000]\n#Number of simulations\nNreps = 100\noptions = (Nsamples=2000,Nadapt=1000,delta=.8,Nd=Nd)speed\nallocations\neffective sample size"
},

{
    "location": "benchmarks/#Linear-Regression-1",
    "page": "Benchmark Results",
    "title": "Linear Regression",
    "category": "section",
    "text": "Modelmu sim Normal(01)sigma sim TCauchy(050infty)Y sim Normal(musigma)\n\n\n* benchmark design\n\n* speed\n* allocations\n* effective sample size\n\n Linear Ballistic Accumulator (LBA)\n\n* Model\nmath \\tau \\sim TNormal(.4,.1,0,y_{min})math A \\sim TNormal(.8,.4,0,\\infty)math k \\sim TNormal(.2,.3,0,\\infty)math v \\sim Normal(0,3)math (t,c) \\sim LBA(A,b,v,s,\\tau)\nwhere\nmath t = yi - t{er}math b = A + kmath s = 1math LBA(A,b,v,s,\\tau) = fc(t)\\prod{j \\neq c} (1-F_j(t))math fc(t) = \\frac{1}{A} \\left[-vc \\Phi\\left( \\frac{b-A-tvc}{ts} \\right) + \\phi\\left( \\frac{b-A-tvc}{ts} \\right) +vc \\Phi\\left( \\frac{b-tvc}{ts} \\right) + s \\phi\\left( \\frac{b-tv_c}{ts} \\right) \\right]math Fc(t) = 1 + \\frac{b-A-tvi}{A}  \\Phi\\left \\frac{b-A-tvc}{ts} \\right) - \\frac{b-tvi}{A}  \\Phi\\left \\frac{b-tvc}{ts} \\right) + \\frac{ts}{A} \\phi \\left(\\frac{b-A-tvc}{ts} \\right) - \\frac{ts}{A} \\phi \\left(\\frac{b-tv_c}{ts} \\right)math Y = {y1,...,yn}math y_{min} = min{Y}\n* benchmark design\n\n* speed\n* allocations\n* effective sample size\n\n### Poisson Regression\n\n* Model\nmath a_0 \\sim Normal(0,10)math a_1 \\sim Normal(0,1)math \\sigma_{a0} \\sim TCauchy(0,1,0,\\infty)math a{0i} ~ \\sim Normal(0,\\sigma{a0})math \\lambda = e^(a0 + a{0i} + a1*xi)math y_i \\sim Poisson(\\lambda)\n* benchmark design\njulia #Number of data points per unit Nd = [1,2,5] #Number of units in model Ns = 10 #Number of simulations Nreps = 25 options = (Nsamples=2000,Nadapt=1000,delta=.8,Nd=Nd,Ns=Ns) ```speed\nallocations\neffective sample size"
},

]}
