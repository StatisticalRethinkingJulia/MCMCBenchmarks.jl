using MCMCBenchmarks,Test

@testset "Turing Gaussian Test " begin
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
      DHMCNUTS(sampleDHMC,2000))
    data = GaussianGen(;Nd=Nd,μ=mu,σ=sigma)
    options = (Nsamples=2000,Nadapt=1000,delta=.8,Nd=Nd)
    results = benchmark(samplers,GaussianGen,Nreps;options...)
    @test results[:mu_mean][results[:sampler] .== :AHMCNUTS,:][1] ≈ mu atol = .05
    @test results[:mu_mean][results[:sampler] .== :CmdStanNUTS,:][1] ≈ mu atol = .05
    @test results[:mu_mean][results[:sampler] .== :DHMCNUTS,:][1] ≈ mu atol = .05
    @test results[:sigma_mean][results[:sampler] .== :AHMCNUTS,:][1] ≈ sigma atol = .05
    @test results[:sigma_mean][results[:sampler] .== :CmdStanNUTS,:][1] ≈ sigma atol = .05
    @test results[:sigma_mean][results[:sampler] .== :DHMCNUTS,:][1] ≈ sigma atol = .05
    @test results[:mu_r_hat][results[:sampler] .== :AHMCNUTS,:][1] ≈ 1 atol = .03
    @test results[:mu_r_hat][results[:sampler] .== :CmdStanNUTS,:][1] ≈ 1 atol = .03
    @test results[:mu_r_hat][results[:sampler] .== :DHMCNUTS,:][1] ≈ 1 atol = .03
    @test results[:sigma_r_hat][results[:sampler] .== :AHMCNUTS,:][1] ≈ 1 atol = .03
    @test results[:sigma_r_hat][results[:sampler] .== :CmdStanNUTS,:][1] ≈ 1 atol = .03
    @test results[:sigma_r_hat][results[:sampler] .== :DHMCNUTS,:][1] ≈ 1 atol = .03
    isdir("tmp") && rm("tmp", recursive=true)
end
