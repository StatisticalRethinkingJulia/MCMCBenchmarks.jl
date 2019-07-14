using MCMCBenchmarks,Test
tests = [
"generative_model_tests",
"Gaussian_Tests",
"SDT_Tests",
"LBA_Tests",
"Poisson_Test",
"Regression_Tests"
]

res = map(tests) do t
    @eval module $(Symbol("Test_", t))
        include($t * ".jl")
    end
end
