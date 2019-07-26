using MCMCBenchmarks,Test,Random
Random.seed!(454)
tests = [
    "generative_model_tests",
    "Gaussian_Tests",
    "SDT_Tests",
    "Poisson_Test",
    "Regression_Tests",
    "Plot_Tests",
    "LBA_Tests"
]

res = map(tests) do t
    @eval module $(Symbol("Test_", t))
        include($t * ".jl")
    end
end
