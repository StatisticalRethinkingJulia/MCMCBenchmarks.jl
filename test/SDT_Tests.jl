using MCMCBenchmarks,Test

@testset "SDT Tests " begin
    path = pathof(MCMCBenchmarks)
    include(joinpath(path,"../../Models/SDT/SDT_Functions.jl"))
    include(joinpath(path,"../../Models/SDT/SDT.jl"))
    Nd=10^4
    d = 2.0
    c = 0.0
    Nreps = 1
    ProjDir = @__DIR__
    cd(ProjDir)
    samplers=(CmdStanNUTS(CmdStanConfig,ProjDir),
        AHMCNUTS(AHMC_SDT,AHMCconfig),
        DHMCNUTS(sampleDHMC,2000))
    options = (Nsamples=2000,Nadapt=1000,delta=.8,Nd=Nd)
    results = benchmark(samplers,simulateSDT,Nreps;options...)
    @test results[!,:d_mean][results[!,:sampler] .== :AHMCNUTS,:][1] ≈ d atol = .05
    @test results[!,:d_mean][results[!,:sampler] .== :CmdStanNUTS,:][1] ≈ d atol = .05
    @test results[!,:d_mean][results[!,:sampler] .== :DHMCNUTS,:][1] ≈ d atol = .05
    @test results[!,:c_mean][results[!,:sampler] .== :AHMCNUTS,:][1] ≈ c atol = .05
    @test results[!,:c_mean][results[!,:sampler] .== :CmdStanNUTS,:][1] ≈ c atol = .05
    @test results[!,:c_mean][results[!,:sampler] .== :DHMCNUTS,:][1] ≈ c atol = .05
    @test results[!,:d_sampler_rhat][1] ≈ 1 atol = .03
    @test results[!,:c_sampler_rhat][1] ≈ 1 atol = .03
    isdir("tmp") && rm("tmp", recursive=true)
end
