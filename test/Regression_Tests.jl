using MCMCBenchmarks, Test, Random

@testset "Regression Tests " begin
    Random.seed!(22385)
    path = pathof(MCMCBenchmarks)
    include(joinpath(path,
      "../../Models/Linear_Regression/Linear_Regression_Models.jl"))
    Nd = 50
    β0 = 1
    β = fill(.5,1)
    σ = 1
    Nreps = 1
    ProjDir = @__DIR__
    cd(ProjDir)
    samplers = (
      CmdStanNUTS(CmdStanConfig,ProjDir),
      AHMCNUTS(AHMCregression,AHMCconfig),
      DHMCNUTS(sampleDHMC))
    options = (Nsamples=2000,Nadapt=1000,delta=.8,Nd=Nd)
    results = benchmark(samplers,simulateRegression,Nreps;options...)
    @test isa(results,DataFrame)
    # @test results[!,Symbol("B[1]_mean")][results[!,:sampler] .== :AHMCNUTS,:][1] ≈ β[1] atol = .1
    # @test results[!,Symbol("B[1]_mean")][results[!,:sampler] .== :CmdStanNUTS,:][1] ≈ β[1] atol = .1
    # @test results[!,Symbol("B[1]_mean")][results[!,:sampler] .== :DHMCNUTS,:][1] ≈ β[1] atol = .1
    # @test results[!,:B0_mean][results[!,:sampler] .== :AHMCNUTS,:][1] ≈ β0[1] atol = .1
    # @test results[!,:B0_mean][results[!,:sampler] .== :CmdStanNUTS,:][1] ≈ β0[1] atol = .1
    # @test results[!,:B0_mean][results[!,:sampler] .== :DHMCNUTS,:][1] ≈ β0[1] atol = .1
    # @test results[!,:sigma_mean][results[!,:sampler] .== :AHMCNUTS,:][1] ≈ σ atol = .1
    # @test results[!,:sigma_mean][results[!,:sampler] .== :CmdStanNUTS,:][1] ≈ σ atol = .1
    # @test results[!,:sigma_mean][results[!,:sampler] .== :DHMCNUTS,:][1] ≈ σ atol = .1
    # @test results[!,Symbol("B[1]_sampler_rhat")][1] ≈ 1 atol = .03
    # @test results[!,:B0_sampler_rhat][1] ≈ 1 atol = .03
    # @test results[!,:sigma_sampler_rhat][1] ≈ 1 atol = .03
    isdir("tmp") && rm("tmp", recursive=true)
end
