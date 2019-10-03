using MCMCBenchmarks,Test

@testset "Gaussian Tests " begin
    path = pathof(MCMCBenchmarks)
    include(joinpath(path, "../../Models/Gaussian/Gaussian_Models.jl"))
    mu = 0
    sigma = 1
    Nd = 10^3
    Nreps = 1
    ProjDir = @__DIR__
    cd(ProjDir)
    samplers=(
      CmdStanNUTS(CmdStanConfig,ProjDir),
      AHMCNUTS(AHMCGaussian,AHMCconfig),
      DHMCNUTS(sampleDHMC))
    options = (Nsamples=2000,Nadapt=1000,delta=.8,Nd=Nd)
    results = benchmark(samplers,simulateGaussian,Nreps;options...)
    @test results[!,:mu_mean][results[!,:sampler] .== :AHMCNUTS,:][1] ≈ mu atol = .05
    @test results[!,:mu_mean][results[!,:sampler] .== :CmdStanNUTS,:][1] ≈ mu atol = .05
    @test results[!,:mu_mean][results[!,:sampler] .== :DHMCNUTS,:][1] ≈ mu atol = .05
    @test results[!,:sigma_mean][results[!,:sampler] .== :AHMCNUTS,:][1] ≈ sigma atol = .05
    @test results[!,:sigma_mean][results[!,:sampler] .== :CmdStanNUTS,:][1] ≈ sigma atol = .05
    @test results[!,:sigma_mean][results[!,:sampler] .== :DHMCNUTS,:][1] ≈ sigma atol = .05
    @test results[!,:mu_sampler_rhat][1] ≈ 1 atol = .03
    @test results[!,:sigma_sampler_rhat][1] ≈ 1 atol = .03
    isdir("tmp") && rm("tmp", recursive=true)
end
