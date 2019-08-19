using CSV, DataFrames, Statistics

results_dir = ARGS[1]
results = CSV.read("$results_dir/results.csv")

by(results, [:sampler, :Nd], :tau_ess=>mean, :A_ess=>mean, :k_ess=>mean, Symbol("v[1]_ess")=>mean, Symbol("v[2]_ess")=>mean, Symbol("v[3]_ess")=>mean, :tree_depth=>mean, :epsilon=>mean) |> println