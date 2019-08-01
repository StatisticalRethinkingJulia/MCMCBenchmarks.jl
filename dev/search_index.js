var documenterSearchIndex = {"docs": [

{
    "location": "#",
    "page": "MCMCBenchmarks.jl Documentation",
    "title": "MCMCBenchmarks.jl Documentation",
    "category": "page",
    "text": ""
},

{
    "location": "#MCMCBenchmarks.jl-Documentation-1",
    "page": "MCMCBenchmarks.jl Documentation",
    "title": "MCMCBenchmarks.jl Documentation",
    "category": "section",
    "text": ""
},

{
    "location": "#Purpose-1",
    "page": "MCMCBenchmarks.jl Documentation",
    "title": "Purpose",
    "category": "section",
    "text": "Bayesian inference is a flexible and popular statistical framework that is used in numerous fields of science, engineering, and machine learning. The goal of Bayesian inference is to learn about likely parameter values of a model through observed data. The end product of Bayesian inference is a posterior distribution over the parameter space P(Θ|Y), which quantifies uncertainty in the parameter values. Because real-world models do not have analytical solutions for P(Θ|Y), computational methods, such as MCMC sampling algorithms, are used to approximate analytical solutions, and form the basis of Bayesian inference.Given the ubiquity of Bayesian inference, it is important to understand the features and performance of available MCMC sampler packages. MCMCBenchmarks.jl aims to accomplish three goals: (1) help Julia users decide which MCMC samplers to use on the basis of performance, (2) help Julia developers identify performance issues, and (3) provide a flexible framework for benchmarking models and samplers aside from those included in the package."
},

{
    "location": "#Benchmarking-Challenges-1",
    "page": "MCMCBenchmarks.jl Documentation",
    "title": "Benchmarking Challenges",
    "category": "section",
    "text": "One of the challenges with benchmarking MCMC samplers is the lack of uniform interface. Some samplers may require different arguments or configurations because they function differently or are associated with different packages. In addition, models used for benchmarking differ in terms of parameters, data structure, and function arguments. Without a unifying framework, benchmarking MCMC samplers can be cumbersome, resulting one-off scripts and inflexible code. Our goal in developing MCMCBenchmarks was to fulfill this need for a unifying framework."
},

{
    "location": "#Basic-Design-1",
    "page": "MCMCBenchmarks.jl Documentation",
    "title": "Basic Design",
    "category": "section",
    "text": "MCMCBenchmarks uses a combination of multiple dispatch and optional keyword arguments to satisfy the differing requirements of MCMC samplers and models. Benchmark routines are performed with three primary overloaded functions:runSampler: passes necessary arguments to sampler and runs the sampler\nupdateResults: adds benchmark performance data to a results DataFrame\nmodifyConfig: modifies the configuration of the samplerThese functions are overloaded with sampler-specific methods, ensuring that the requirements for each sampler are satisfied. Additional flexibility is gained through the use of optional keyword arguments. Each method captures relevant keyword arguments and collects irrelevant arguments in kwargs... where they are ignored."
},

{
    "location": "#Features-1",
    "page": "MCMCBenchmarks.jl Documentation",
    "title": "Features",
    "category": "section",
    "text": "Flexible: specify factors to vary in your benchmark, such as number of MCMC samples, MCMC configuration, the size of datasets, and data generating parameters\nParallel: distribute your benchmark over multiple processors to produce efficient benchmarks\nExtendable: use multiple dispatch to benchmark new samplers\nPerformance Metrics: r̂,effective sample size, effective sample size per second, run time, percentage of time in garbage collection, MBs of memory allocated, number of memory allocations.\nPlots: density plots, summary plots, scatter plots, parameter recovery plots"
},

{
    "location": "#Index-1",
    "page": "MCMCBenchmarks.jl Documentation",
    "title": "Index",
    "category": "section",
    "text": ""
},

{
    "location": "functions/#",
    "page": "-",
    "title": "-",
    "category": "page",
    "text": ""
},

{
    "location": "functions/#MCMCBenchmarks.MCMCSampler",
    "page": "-",
    "title": "MCMCBenchmarks.MCMCSampler",
    "category": "type",
    "text": "Abstract MCMC sampler type\n\n\n\n\n\n"
},

{
    "location": "functions/#MCMCBenchmarks.CmdStanNUTS",
    "page": "-",
    "title": "MCMCBenchmarks.CmdStanNUTS",
    "category": "type",
    "text": "MCMC sampler struct for CmdStan NUTS\n\nmodel: model configuration\ndir: probject directory\n\n\n\n\n\n"
},

{
    "location": "functions/#MCMCBenchmarks.AHMCNUTS",
    "page": "-",
    "title": "MCMCBenchmarks.AHMCNUTS",
    "category": "type",
    "text": "MCMC sampler struct for AdvancedHMC NUTS\n\nmodel: model function that accepts data\nconfig: sampler configution settings\n\n\n\n\n\n"
},

{
    "location": "functions/#MCMCBenchmarks.DHMCNUTS",
    "page": "-",
    "title": "MCMCBenchmarks.DHMCNUTS",
    "category": "type",
    "text": "MCMC sampler struct for DynamicHMC NUTS\n\nmodel: model function that accepts data\nconfig: sampler configution settings\n\n\n\n\n\n"
},

{
    "location": "functions/#Sampler-Structs-1",
    "page": "-",
    "title": "Sampler Structs",
    "category": "section",
    "text": "Each sampler is associated with a MCMC sampler struct, which is a subtype of MCMCSampler. In MCMCBenchmarks, we define subtypes of MCMCSampler for three popular NUTS MCMC samplers in Julia: CmdStan, AdvancedHMC via Turing, and DynamicHMC.MCMCSamplerCmdStanNUTSAHMCNUTSDHMCNUTS"
},

{
    "location": "functions/#Functions-1",
    "page": "-",
    "title": "Functions",
    "category": "section",
    "text": ""
},

{
    "location": "functions/#MCMCBenchmarks.benchmark",
    "page": "-",
    "title": "MCMCBenchmarks.benchmark",
    "category": "function",
    "text": "Runs the benchmarking procedure and returns the results\n\nsamplers: a tuple of samplers or a single sampler object\nsimulate: model simulation function with keyword Nd\nNreps: number of times the benchmark is repeated for each factor combination\n\n\n\n\n\n"
},

{
    "location": "functions/#MCMCBenchmarks.pbenchmark",
    "page": "-",
    "title": "MCMCBenchmarks.pbenchmark",
    "category": "function",
    "text": "Runs the benchmarking procedure defined in benchmark in parallel and returns the results\n\nsamplers: a tuple of samplers or a single sampler object\nsimulate: model simulation function with keyword Nd\nNreps: number of times the benchmark is repeated for each factor combination\n\n\n\n\n\n"
},

{
    "location": "functions/#MCMCBenchmarks.benchmark!",
    "page": "-",
    "title": "MCMCBenchmarks.benchmark!",
    "category": "function",
    "text": "Primary function that performs mcmc benchmark repeatedly on a set of samplers and records the results.\n\n\'sampler\': tuple of sampler objects\nresults: DataFrame containing benchmark results\ncsr̂: cross sampler r̂\nsimulate: data generating function\nNreps: number of repetitions for a given set of simulation parameters. Default = 100\nkwargs: optional keyword arguments that are passed to modifyConfig!, updateResults! and\n\nrunSampler, providing flexibility in benchmark simulations.\n\n\n\n\n\n"
},

{
    "location": "functions/#Top-level-Benchmark-Routines-1",
    "page": "-",
    "title": "Top-level Benchmark Routines",
    "category": "section",
    "text": "benchmarkpbenchmarkbenchmark!"
},

{
    "location": "functions/#MCMCBenchmarks.modifyConfig!",
    "page": "-",
    "title": "MCMCBenchmarks.modifyConfig!",
    "category": "function",
    "text": "Modifies MCMC sampler configuration, including number of samples, target acceptance rate and others depending on the specific sampler.\n\ns: sampler object\nNsamples: total number of MCMC samples\nNadapt: number of adaption samples during warm up\ndelta: target acceptance rate.\n\n\n\n\n\n"
},

{
    "location": "functions/#MCMCBenchmarks.updateResults!",
    "page": "-",
    "title": "MCMCBenchmarks.updateResults!",
    "category": "function",
    "text": "Update the results DataFrame on each iteration\n\ns: MCMC sampler object\nperformance: includes MCMC Chain, execution time, and memory measurements\nresults: DataFrame containing benchmark results\n\n\n\n\n\n"
},

{
    "location": "functions/#MCMCBenchmarks.runSampler",
    "page": "-",
    "title": "MCMCBenchmarks.runSampler",
    "category": "function",
    "text": "Extracts model and configuration from sampler object and performs parameter estimation\n\ns: sampler object\ndata: data for benchmarking\n\n\n\n\n\n"
},

{
    "location": "functions/#Overloaded-Benchmark-Functions-1",
    "page": "-",
    "title": "Overloaded Benchmark Functions",
    "category": "section",
    "text": "modifyConfig!updateResults!runSampler"
},

{
    "location": "functions/#MCMCBenchmarks.addPerformance!",
    "page": "-",
    "title": "MCMCBenchmarks.addPerformance!",
    "category": "function",
    "text": "Adds performance metrics to benchmark results, which include runtime, memory allocations in MB, garbage collection time, percent of time spent in garbage collection, and the number of memory allocations\n\ndf: the dataframe to which performance metrics are added\np: a collection of performance metrics including run time,\n\nmemory allocations and garbage collection time\n\n\n\n\n\n"
},

{
    "location": "functions/#MCMCBenchmarks.addKW!",
    "page": "-",
    "title": "MCMCBenchmarks.addKW!",
    "category": "function",
    "text": "Adds keyword arguments to the results DataFrame\n\ndf: DataFrame containing benchmark results for single iteration\nkwargs: keyword arguments\n\n\n\n\n\n"
},

{
    "location": "functions/#MCMCBenchmarks.addChainSummary!",
    "page": "-",
    "title": "MCMCBenchmarks.addChainSummary!",
    "category": "function",
    "text": "Adds chain summary (e.g. rhat,ess) to newDF for each parameter.\n\nnewDF: dataframe that collects results on an iteration\nchn: chain for given iteration\ndf: df of chain results\ncol: name of column\n\ne.g. If col = :ess, and parameters are mu and sigma, the new columns will be muess and sigmaess and will contain their respective ess values\n\n\n\n\n\n"
},

{
    "location": "functions/#Helper-Functions-1",
    "page": "-",
    "title": "Helper Functions",
    "category": "section",
    "text": "addPerformance!addKW!addChainSummary!addHPD!addMeans!"
},

{
    "location": "functions/#MCMCBenchmarks.plotdensity",
    "page": "-",
    "title": "MCMCBenchmarks.plotdensity",
    "category": "function",
    "text": "Plots a desnity of a distribution for a selected metric (e.g. effective sample size)\n\ndf: dataframe of results\nmetric: name of metric, such as :ess for effective sample size\ngroup: a tuple of grouping factors, e.g. (:sampler,:Nd)\nsave: save=true saves each plot\nfigfmt: figure format\ndir: directory of saved plot. Default pwd.\n\n\n\n\n\n"
},

{
    "location": "functions/#MCMCBenchmarks.plotsummary",
    "page": "-",
    "title": "MCMCBenchmarks.plotsummary",
    "category": "function",
    "text": "Plots a summary of a metric computed according to a function, func. func defaults to the mean.\n\ndf: dataframe of results\nxvar: variable assigned to x-axis\nmetric: name of metric, such as :ess for effective sample size\ngroup: a tuple of grouping factors, e.g. (:sampler,:Nd)\nsave: save=true saves each plot\nfigfmt: figure format\nfunc: a function used to summarize results. Default mean\ndir: directory of saved plot. Default pwd.\n\n\n\n\n\n"
},

{
    "location": "functions/#MCMCBenchmarks.plotscatter",
    "page": "-",
    "title": "MCMCBenchmarks.plotscatter",
    "category": "function",
    "text": "Generates a scatter plot to visualize the relationship between two benchmarking metrics.\n\ndf: dataframe of results\nxvar: variable assigned to x-axis\nmetric: name of metric, such as :ess for effective sample size\ngroup: a tuple of grouping factors, e.g. (:sampler,:Nd)\nsave: save=true saves each plot\nfigfmt: figure format\nfunc: a function used to summarize results. Default mean\ndir: directory of saved plot. Default pwd.\n\n\n\n\n\n"
},

{
    "location": "functions/#MCMCBenchmarks.plotrecovery",
    "page": "-",
    "title": "MCMCBenchmarks.plotrecovery",
    "category": "function",
    "text": "Generates a plot to compare the estimated parameters to true parameter values used to generate simulated data.\n\ndf: dataframe of results\nparms: namedtuple of parameter names and true values\ngroup: a tuple of grouping factors, e.g. (:sampler,:Nd)\nsave: save=true saves each plot\nfigfmt: figure format\nfunc: a function used to summarize results. Default mean\ndir: directory of saved plot. Default pwd.\n\n\n\n\n\n"
},

{
    "location": "functions/#Plotting-1",
    "page": "-",
    "title": "Plotting",
    "category": "section",
    "text": "plotdensityplotsummaryplotscatterplotrecovery"
},

{
    "location": "functions/#Results-DataFrame-1",
    "page": "-",
    "title": "Results DataFrame",
    "category": "section",
    "text": ""
},

{
    "location": "example/#",
    "page": "-",
    "title": "-",
    "category": "page",
    "text": ""
},

{
    "location": "example/#Example-1",
    "page": "-",
    "title": "Example",
    "category": "section",
    "text": ""
},

{
    "location": "example/#Model-1",
    "page": "-",
    "title": "Model",
    "category": "section",
    "text": "In this detailed example, we will guide users through the process of developing a benchmark within MCMCBenchmarks. To make matters as simple as possible, we will benchmark CmdnStan, AdvancedHMC, and DynamicHMC with a simple Gaussian model. Assume that a vector of observations Y follows a Gaussian distribution with parameters μ and σ, which have Gaussian and Truncated Cauchy prior distributions, respectively. Formally, the Gaussian model is defined as follows:\"\"\" \\mu ~ Normal(0,1) \\sigma ~ TCauchy(0,5,0,\\infty) \\Y ~ Normal(\\mu,\\sigma) \"\"\""
},

{
    "location": "example/#Benchmark-Design-1",
    "page": "-",
    "title": "Benchmark Design",
    "category": "section",
    "text": "In this example, we will generate data from a Gaussian distribution with parameters μ = 0 and σ = 1 for three sample sizes Nd = [10, 100, 1000]. Each sampler will run for Nsamples = 2000 iterations, Nadapt = 1000 of which are adaption or warmup iterations. The target acceptance rate is set to delta = .8. The benchmark will be repeated 50 times with a different sample of simulated data to ensure that the results are robust across datasets. This will result in 450 benchmarks, (3 (samplers) X 3 (sample sizes) X 50 (repetitions))."
},

{
    "location": "example/#Code-Structure-1",
    "page": "-",
    "title": "Code Structure",
    "category": "section",
    "text": "In order to perform a benchmark, the user must define the following:A top-level script for calling the necessary functions and specifying the benchmark design. The corresponding code can be found in MCMCBenchmarks/Examples/Gaussian/Gaussian_Example.jl.\nModels defined for each of the samplers with a common naming scheme for parameters. The corresponding code can be found in MCMCBenchmarks/Models/Gaussian/Gaussian_Models.jl.\nSampler specific struct and methods defined for updateResults!, modifyConfig!, and runSampler. Structs and methods for NUTS in CmdStan, AdvancedHMC/Turing, and DynamicHMC are provided by MCMCBenchmarks.We will walk through the code in the top-level script named Gaussian_Example.jl. In the first snippet, we call the required packages, set the number of chains to 4, set the file directory as the project directory, remove old the old CmdStan output director tmp and create a new one, then create a results folder if one does not already exist.  using Revise,MCMCBenchmarks,Distributed\nNchains=4\nsetprocs(Nchains)\n\nProjDir = @__DIR__\ncd(ProjDir)\n\nisdir(\"tmp\") && rm(\"tmp\", recursive=true)\nmkdir(\"tmp\")\n!isdir(\"results\") && mkdir(\"results\")In the following code snippet, we set the path to the Gaussian model file and load them on each of the workers. Next, we suppress the printing of Turing\'s progress and set a seed on each worker.path = pathof(MCMCBenchmarks)\n@everywhere begin\n  using MCMCBenchmarks,Revise\n  #Model and configuration patterns for each sampler are located in a\n  #seperate model file.\n  include(joinpath($path, \"../../Models/Gaussian/Gaussian_Models.jl\"))\nend\n\n#run this on primary processor to create tmp folder\ninclude(joinpath(path,\n  \"../../Models/Gaussian/Gaussian_Models.jl\"))\n\n@everywhere Turing.turnprogress(false)\n#set seeds on each processor\nseeds = (939388,39884,28484,495858,544443)\nfor (i,seed) in enumerate(seeds)\n    @fetch @spawnat i Random.seed!(seed)\nendThe follow snippet creates a tuple of samplers and initializes a CmdStan output folder for each worker.#create a sampler object or a tuple of sampler objects\nsamplers=(\n  CmdStanNUTS(CmdStanConfig,ProjDir),\n  AHMCNUTS(AHMCGaussian,AHMCconfig),\n  DHMCNUTS(sampleDHMC,2000))\n\nstanSampler = CmdStanNUTS(CmdStanConfig,ProjDir)\n#Initialize model files for each instance of stan\ninitStan(stanSampler)At this point, we can define the benchmark design. The design configuration is collected in the NamedTuple called options. MCMCBenchmarks will perform Nrep = 50 repetitions for each combinations of factors defined in options. The number of combinations is computed as: prod(length.(values(options))). In this example, there are three combinations:(Nsamples=2000,Nadapt=1000,delta=.8,Nd=10)\n(Nsamples=2000,Nadapt=1000,delta=.8,Nd=100)\n(Nsamples=2000,Nadapt=1000,delta=.8,Nd=1000)If we set delta = [.65, .80] instead of delta = .80, there would be 6 combinations.#Number of data points\nNd = [10, 100, 1000]\n\n#Number of simulations\nNreps = 50\n\noptions = (Nsamples=2000,Nadapt=1000,delta=.8,Nd=Nd)The function pbenchmark performs the benchmarks in parallel, by dividing the jobs across the available processors. pbenchmark accepts the tuple of samplers, the data generating function, the number of repetitions, and the design options. Upon completion, a DataFrame containing the benchmarks and configuration information is returned. #perform the benchmark\nresults = pbenchmark(samplers,simulateGaussian,Nreps;options...)After the benchmark has completed, the results are saved in the results as a csv file. In addition, relevant package version information and system information is saved in a seperate csv file.#save results\nsave(results,ProjDir)"
},

{
    "location": "example/#Results-Output-1",
    "page": "-",
    "title": "Results Output",
    "category": "section",
    "text": "The following information is stored in the results DataFrame:Each parameter is associated with a column for each of the following quantities: Effective Sample Size, Effective Sample Size per second, cross-sampler r̂\nA sampler name column\nThe column for each design element in the options NamedTuple\nA column for each of following performance metrics: run time, % garbage collection time, number of memory allocations, the amount of memory allocated in MB"
},

{
    "location": "benchmarks/#",
    "page": "-",
    "title": "-",
    "category": "page",
    "text": ""
},

{
    "location": "benchmarks/#Benchmark-Results-1",
    "page": "-",
    "title": "Benchmark Results",
    "category": "section",
    "text": "speed\nallocations\neffective sample size"
},

{
    "location": "benchmarks/#Gaussian-1",
    "page": "-",
    "title": "Gaussian",
    "category": "section",
    "text": "Modelmu sim Normal(01)\nsigma sim TCauchy(050infty)\nY sim Normal(musigma)benchmark design\nspeed\nallocations\neffective sample size"
},

{
    "location": "benchmarks/#Signal-Detection-Theory-1",
    "page": "-",
    "title": "Signal Detection Theory",
    "category": "section",
    "text": "Modeld sim Normal(01sqrt(2))\nc sim Normal(01sqrt(2))\n\ntheta_hits = ϕ(d2-c)\ntheta_fas = ϕ(-d2-c)\n\nn_hits sim Normal(mutheta_hits)\nn_fas sim Binomial(Ntheta_fas)benchmark design\nspeed\nallocations\neffective sample size"
},

{
    "location": "benchmarks/#Linear-Regression-1",
    "page": "-",
    "title": "Linear Regression",
    "category": "section",
    "text": "Modelmu sim Normal(01)\nsigma sim TCauchy(050infty)\nY sim Normal(musigma)benchmark design\nspeed\nallocations\neffective sample size"
},

{
    "location": "benchmarks/#Linear-Ballistic-Accumulator-(LBA)-1",
    "page": "-",
    "title": "Linear Ballistic Accumulator (LBA)",
    "category": "section",
    "text": "Model\n\ntau sim TNormal(410y_min)\nA sim TNormal(840infty)\nk sim TNormal(230infty)\nv sim Normal(03)\n(tc) sim LBA(Abvstau)wheret = y_i - t_er\nb = A + k\ns = 1\nLBA(Abvstau) = f_c(t)prod_j neq c (1-F_j(t))\nf_c(t) = fract1A left-v_c Phileft( fractb-A-tv_cts right) + phileft( fractb-A-tv_cts right) +\n+ v_c Phileft( fractb-tv_cts right) + s phileft( fractb-tv_cts right)\n\n  right\nF_c(t) = 1 + fractb-A-tv_iA  Phileft fractb-A-tv_cts right) - fractb-tv_iA  Phileft fractb-tv_cts right) + fracttsA phi left(fractb-A-tv_cts right) - fracttsA phi left(fractb-tv_cts right)\nY = y_1y_n\ny_min = minYbenchmark design\nspeed\nallocations\neffective sample size"
},

{
    "location": "benchmarks/#Poisson-Regression-1",
    "page": "-",
    "title": "Poisson Regression",
    "category": "section",
    "text": "Modela_0 sim Normal(010)\na_1 sim Normal(01)\nsigma_a0 sim TCauchy(010infty)\na_0i  sim Normal(0sigma_a0)\nlambda = e^(a_0 + a_0i + a_1*x_i)\ny_i sim Poisson(lambda)benchmark design\nspeed\nallocations\neffective sample size"
},

]}
