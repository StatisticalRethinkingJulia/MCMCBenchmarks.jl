using MCMCBenchmarks, Test, Random

@testset "Poisson Regression Tests " begin
    Random.seed!(641)
    path = pathof(MCMCBenchmarks)
    include(joinpath(path,
      "../../Models/Hierarchical_Poisson/Hierarhical_Poisson_Models.jl"))
    Nd = 1
    Nreps = 1
    Ns = 10
    a0 = 1.0
    a1 = .5
    a0_sig = .3
    ProjDir = @__DIR__
    cd(ProjDir)
    samplers = (
      CmdStanNUTS(CmdStanConfig, ProjDir),
      AHMCNUTS(AHMCpoisson, AHMCconfig),
      #DHMCNUTS(sampleDHMC)
      )
    options = (Nsamples=2000, Nadapt=1000, delta=.8, Nd=Nd, Ns=Ns)
    results = benchmark(samplers, simulatePoisson, Nreps;options...)
    #Models run slow and these are noisy
    @test results[!,:a0_mean][results[!,:sampler] .== :AHMCNUTS,:][1] ≈ a0 atol = .6
    @test results[!,:a0_mean][results[!,:sampler] .== :CmdStanNUTS,:][1] ≈ a0 atol = .6
    #@test results[!,:a0_mean][results[!,:sampler] .== :DHMCNUTS,:][1] ≈ a0 atol = .6
    @test results[!,:a1_mean][results[!,:sampler] .== :AHMCNUTS,:][1] ≈ a1 atol = .6
    @test results[!,:a1_mean][results[!,:sampler] .== :CmdStanNUTS,:][1] ≈ a1 atol = .6
    #@test results[!,:a1_mean][results[!,:sampler] .== :DHMCNUTS,:][1] ≈ a1 atol = .6
    @test results[!,:a0_sig_mean][results[!,:sampler] .== :AHMCNUTS,:][1] ≈ a1 atol = .6
    @test results[!,:a0_sig_mean][results[!,:sampler] .== :CmdStanNUTS,:][1] ≈ a1 atol = .6
    #@test results[!,:a0_sig_mean][results[!,:sampler] .== :DHMCNUTS,:][1] ≈ a1 atol = .6
    @test results[!,:a0_sampler_rhat][1] ≈ 1 atol = .03
    @test results[!,:a1_sampler_rhat][1] ≈ 1 atol = .03
    @test results[!,:a0_sig_sampler_rhat][1] ≈ 1 atol = .03
    isdir("tmp") && rm("tmp", recursive=true)
end
