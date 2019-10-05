using MCMCBenchmarks, Test, Random

@testset "LBA Tests " begin
    Random.seed!(2215)
    path = pathof(MCMCBenchmarks)
    include(joinpath(path, "../../Models/LBA/LBA_Models.jl"))
    include(joinpath(path, "../../Models/LBA/LinearBallisticAccumulator.jl"))
    Nd = 250
    v = [1.0,1.5,2.0]
    A = .8
    k = .2
    tau = .4
    Nreps = 1
    ProjDir = @__DIR__
    cd(ProjDir)
    samplers = (
      CmdStanNUTS(CmdStanConfig,ProjDir),
      AHMCNUTS(AHMClba,AHMCconfig),
      #DHMCNUTS(sampleDHMC)
      )
    options = (Nsamples=2000,Nadapt=1000,delta=.8,Nd=Nd)
    results = benchmark(samplers,simulateLBA,Nreps;options...)
    @test results[!,Symbol("v[1]_mean")][results[!,:sampler] .== :AHMCNUTS,:][1] ≈ v[1] atol = .7
    @test results[!,Symbol("v[1]_mean")][results[!,:sampler] .== :CmdStanNUTS,:][1] ≈ v[1] atol = .7
    #@test results[!,Symbol("v[1]_mean")][results[!,:sampler] .== :DHMCNUTS,:][1] ≈ v[1] atol = .7
    @test results[!,Symbol("v[2]_mean")][results[!,:sampler] .== :AHMCNUTS,:][1] ≈ v[2] atol = .7
    @test results[!,Symbol("v[2]_mean")][results[!,:sampler] .== :CmdStanNUTS,:][1] ≈ v[2] atol = .7
    #@test results[!,Symbol("v[2]_mean")][results[!,:sampler] .== :DHMCNUTS,:][1] ≈ v[2] atol = .7
    @test results[!,Symbol("v[3]_mean")][results[!,:sampler] .== :AHMCNUTS,:][1] ≈ v[3] atol = .7
    @test results[!,Symbol("v[3]_mean")][results[!,:sampler] .== :CmdStanNUTS,:][1] ≈ v[3] atol = .7
    #@test results[!,Symbol("v[3]_mean")][results[!,:sampler] .== :DHMCNUTS,:][1] ≈ v[3] atol = .7
    @test results[!,:A_mean][results[!,:sampler] .== :AHMCNUTS,:][1] ≈ A atol = .6
    @test results[!,:A_mean][results[!,:sampler] .== :CmdStanNUTS,:][1] ≈ A atol = .6
    #@test results[!,:A_mean][results[!,:sampler] .== :DHMCNUTS,:][1] ≈ A atol = .6
    @test results[!,:k_mean][results[!,:sampler] .== :AHMCNUTS,:][1] ≈ k atol = .2
    @test results[!,:k_mean][results[!,:sampler] .== :CmdStanNUTS,:][1] ≈ k atol = .2
    #@test results[!,:k_mean][results[!,:sampler] .== :DHMCNUTS,:][1] ≈ k atol = .2
    @test results[!,:tau_mean][results[!,:sampler] .== :AHMCNUTS,:][1] ≈ tau atol = .2
    @test results[!,:tau_mean][results[!,:sampler] .== :CmdStanNUTS,:][1] ≈ tau atol = .2
    #@test results[!,:tau_mean][results[!,:sampler] .== :DHMCNUTS,:][1] ≈ tau atol = .2
    # @test results[!,Symbol("v[1]_sampler_rhat")][1] ≈ 1 atol = .05
    # @test results[!,Symbol("v[2]_sampler_rhat")][1] ≈ 1 atol = .05
    # @test results[!,Symbol("v[3]_sampler_rhat")][1] ≈ 1 atol = .05
    # @test results[!,:A_sampler_rhat][1] ≈ 1 atol = .05
    # @test results[!,:k_sampler_rhat][1] ≈ 1 atol = .05
    # @test results[!,:tau_sampler_rhat][1] ≈ 1 atol = .05
    isdir("tmp") && rm("tmp", recursive=true)
end
