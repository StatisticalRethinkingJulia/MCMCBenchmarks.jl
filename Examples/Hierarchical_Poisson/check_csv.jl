using CSV, DataFrames, Statistics

results_dir = ARGS[1]
results = CSV.read("$results_dir/results.csv")

by(results, [:sampler, :Nd], :a0_ess=>mean, :a1_ess=>mean, :a0_sig_ess=>mean, :tree_depth=>mean, :epsilon=>mean) |> println
