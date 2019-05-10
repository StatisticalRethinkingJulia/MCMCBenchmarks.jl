using CmdStan, Turing,DynamicHMC,LogDensityProblems,Statistics
using Random,Distributions,Parameters,DataFrames,StatsPlots

include("../benchmarks/initial/dHMCdHMC/test_1a.jl")

Random.seed!(38445)

ProjDir = @__DIR__
cd(ProjDir)

Nsamples = 2000
Nadapt = 1000
Nchains = 1

function timing(N, Niters)
  local t = 0.0
  local ttmp = 0.0
  local count = 0
  local success = true
  local iter = 1
  local chns_d
  excs = DomainError[]
  global data
  while iter <= Niters
    println("\nIter = $iter\n")
    sleep(1)
    success == true && (data = Dict("y" => rand(Normal(0,1),N), "N" => N))
    try
      ttmp = @elapsed chns_d = dhmc(data, Nsamples)
      success = true
    catch e
      println("\ndHMC: $(e)\n")
      append!(excs, [e])
      count += 1
      success = false
    end
    if success == true
      iter += 1
      t += ttmp
      show(chns_d)
      println()
    end
  end
  return (iter - 1), N, t, count, excs
end

function dataLoop(Ns, nIter=10)
  local e
  excs = DomainError[]
  df = DataFrame(Iters=Int64[], N=Int64[],
    dHMC=Float64[], dHMC_f=Int64[])
  for N in Ns
    iters, nObs, t, c, e = timing(N, nIter)
    append!(excs, e)
    push!(df,vcat(iters, nObs, t, c))
  end
  return (df, excs)
end

Ns = [100, 1000]
df , e = dataLoop(Ns)
println(e)
println()
df
