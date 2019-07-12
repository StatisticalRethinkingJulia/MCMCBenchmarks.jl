using MCMCBenchmarks,Test
tests = [
"generative_model_tests",
"Gaussian_Tests"
]

res = map(tests) do t
    @eval module $(Symbol("Test_", t))
        include($t * ".jl")
    end
end
