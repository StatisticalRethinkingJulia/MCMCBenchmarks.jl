using MCMCBenchmarks, Test, Random
Random.seed!(7841)
path = pathof(MCMCBenchmarks)
@testset "LBA Generative Model " begin
    include(joinpath(path, "../../Models/LBA/LBA_Models.jl"))
    include(joinpath(path, "../../Models/LBA/LinearBallisticAccumulator.jl"))
    v = [1.0,1.5,2.0]
    A = .8
    k = .2
    tau = .3
    Nd = 10^5
    data = simulateLBA(;Nd=Nd,v=v,A=A,k=k,tau=tau)
    @test typeof(data) == NamedTuple{(:choice, :rt, :N, :Nc),Tuple{Array{Int64,1},Array{Float64,1},Int64,Int64}}
    p1 = mean(data.choice .== 1)
    @test p1 ≈ .18 atol=2e-2
    p2 = mean(data.choice .== 2)
    @test p2 ≈ .32 atol=2e-2
end

@testset "Gaussian Generative Model " begin
    include(joinpath(path, "../../Models/Gaussian/Gaussian_Models.jl"))
    mu = 0
    sigma = 1
    Nd = 10^5
    data = simulateGaussian(;Nd=Nd,μ=mu,σ=sigma)
    @test typeof(data) == NamedTuple{(:y, :N),Tuple{Array{Float64,1},Int64}}
    @test mu ≈ mean(data.y) atol=1e-1
    @test sigma ≈ std(data.y) atol=1e-1
end

@testset "Hierarchical Poisson Generative Model " begin
    include(joinpath(path,
    "../../Models/Hierarchical_Poisson/Hierarhical_Poisson_Models.jl"))
    Nd=1
    Ns=10
    a0=1.0
    a1=.5
    a0_sig=.3
    data = simulatePoisson(;Nd=Nd,Ns=Ns,a0=a0,a1=a1,a0_sig=a0_sig)
    @test typeof(data) == NamedTuple{(:y, :x, :idx, :N, :Ns),Tuple{Array{Int64,1},Array{Float64,1},Array{Int64,1},Int64,Int64}}
end

@testset "Signal Detection Generative Model " begin
    include(joinpath(path,"../../Models/SDT/SDT_Functions.jl"))
    include(joinpath(path,"../../Models/SDT/SDT.jl"))
    Nd=10^4
    d = 2.0
    c = 0.0
    data = simulateSDT(;Nd=Nd,d=d,c=c)
    @test typeof(data) == NamedTuple{(:hits, :fas, :Nd),Tuple{Int64,Int64,Int64}}
    hr′ = data.hits/Nd
    far′ = data.fas/Nd
    hr = cdf(Normal(0,1),d/2-c)
    far = cdf(Normal(0,1),-d/2-c)
    @test hr′ ≈ hr atol = .02
    @test far′ ≈ far atol = .02
end

@testset "Linear Regression Generative Model " begin
    include(joinpath(path,
    "../../Models/Linear_Regression/Linear_Regression_Models.jl"))
    Nd=10
    Nc = 2
    β0=1.
    β=fill(.5,Nc)
    σ=1
    data = simulateRegression(;Nd=Nd,Nc=Nc,β=β,β0=β0)
    @test typeof(data) == NamedTuple{(:x, :y, :Nd, :Nc),Tuple{Array{Float64,2},Array{Float64,1},Int64,Int64}}
end
