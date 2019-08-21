module MCMCBenchmarks

using Reexport

@reexport using Turing,MCMCBenchmarks,CmdStan,StatsPlots,Pkg
@reexport using Statistics,DataFrames,Random,Parameters,DynamicHMC
@reexport using LogDensityProblems,TransformVariables,Dates,FillArrays
@reexport using AdvancedHMC,ForwardDiff,Distributed,CSV,SpecialFunctions
import Base: get
import MCMCChains: Chains

include("plotting.jl")
include("Utilities.jl")
include("TOML/print.jl")
include("TOML/TOML.jl")
include("TOML/parser.jl")
include("core_benchmarking.jl")
include("helper_functions.jl")

export
  modifyConfig!,
  addChainSummary!,
  removeBurnin,
  toDict,
  addKW!,
  setreps,
  compileStanModel,
  addPerformance!,
  updateResults!,
  runSampler,
  benchmark!,
  benchmark,
  pbenchmark,
  MCMCSampler,
  AHMCNUTS,
  CmdStanNUTS,
  DHMCNUTS,
  DNNUTS,
  plotdensity,
  plotsummary,
  plotscatter,
  plotrecovery,
  nptochain,
  setprocs,
  save,
  Permutation,
  initChains,
  initStan
  getMetadata
end # module
