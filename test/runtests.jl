using MCMCBenchmarks,Test,Random
Random.seed!(4504)
tests = [
    "Gaussian_Tests",
    "Plot_Tests",
]

res = map(tests) do t
    @eval module $(Symbol("Test_", t))
        include($t * ".jl")
    end
end
