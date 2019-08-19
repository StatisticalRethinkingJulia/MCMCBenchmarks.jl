using CSV, DataFrames, Statistics

results_dir = ARGS[1]
results = CSV.read("$results_dir/results.csv")

by(results, [:sampler, :Nd], :B0_ess=>mean, :sigma_ess=>mean, Symbol("B[1]_ess")=>mean, Symbol("B[2]_ess")=>mean, Symbol("B[3]_ess")=>mean, :tree_depth=>mean, :epsilon=>mean) |> println