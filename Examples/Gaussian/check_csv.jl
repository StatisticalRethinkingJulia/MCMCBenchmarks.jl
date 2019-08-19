using CSV, DataFrames, Statistics

results_dir = ARGS[1]
results = CSV.read("$results_dir/results.csv")

by(results, [:sampler, :Nd], :mu=>mean, :sigma=>mean, :tree_depth=>mean, :epsilon=>mean) |> println
