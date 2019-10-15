## Benchmark Results
In this section, we report key benchmark results comparing Turing, CmdStan, and DynamicHMC for a variety of models. The code for each of the benchmarks can be found in the [Examples](https://github.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl/tree/master/Examples) folder, while the corresponding code for the models in folder named [Models](https://github.com/StatisticalRethinkingJulia/MCMCBenchmarks.jl/tree/master/Models). The benchmarks were performed with the following software and hardware:

* Julia 1.2.0
* CmdStan 5.2.0
* Turing 0.7.0
* AdvancedHMC 0.2.6
* DynamicHMC 2.1.0
* Ubuntu 18.04
* Intel(R) Core(TM) i7-4790K CPU @ 4.00GHz

Before proceeding to the results, a few caveats should be noted. (1) Turing's performance may improve over time as it matures. (2) memory allocations and garbage collection time are not applicable for CmdStan because the heavy lifting is performed in C++ where it is not measured. (3) Compared to Stan, Turing and DynamicHMC exhibit poor scalability in large part due to the use of forward mode autodiff. As soon as the reverse mode autodiff package [Zygote](https://github.com/FluxML/Zygote.jl) matures in Julia, it will become the default autodiff in MCMCBenchmarks.

### Gaussian

* Model

```math
\mu \sim Normal(0,1)
```
```math
\sigma \sim TCauchy(0,5,0,\infty)
```
```math
Y \sim Normal(\mu,\sigma)
```

* benchmark design

```julia
#Number of data points
Nd = [10, 100, 1000, 10_000]
#Number of simulations
Nreps = 50
options = (Nsamples=2000, Nadapt=1000, delta=.8, Nd=Nd)
```

* speed

```@raw html
<img src="images/Gaussian/summary_time.png" width="500"/>
```

* allocations

```@raw html
<img src="images/Gaussian/summary_allocations.png" width="500"/>
```

* effective sample size

```@raw html
<img src="images/Gaussian/density_mu_ess.png" width="700"/>
```


### Signal Detection Theory

* Model

```math
d \sim Normal(0,1/\sqrt(.5))
```
```math
c \sim Normal(0,1/\sqrt(2))
```
```math
\theta_{hits} = ϕ(d/2-c)
```
```math
\theta_{fas} = ϕ(-d/2-c)
```
```math
n_{hits} \sim Binomial(N,\theta_{hits})
```
```math
n_{fas} \sim Binomial(N,\theta_{fas})
```

* benchmark design

```julia
#Number of data points
Nd = [10, 100, 1000, 10_000]
#Number of simulations
Nreps = 100
options = (Nsamples=2000, Nadapt=1000, delta=.8, Nd=Nd)
#perform the benchmark
```

* speed

```@raw html
<img src="images/SDT/summary_time.png" width="500"/>
```

* allocations

```@raw html
<img src="images/SDT/summary_allocations.png" width="500"/>
```

* effective sample size

```@raw html
<img src="images/SDT/density_d_ess.png" width="700"/>
```

### Linear Regression

* Model

```math
\beta_0 \sim Normal(0,10)
```
```math
\boldsymbol{\beta} \sim Normal(0,10)
```
```math
\sigma \sim TCauchy(0,5,0,\infty)
```
```math
\mu = \beta_0 + \boldsymbol{X}\boldsymbol{\beta}
```
```math
Y \sim Normal(\mu,\sigma)
```

* benchmark design

```julia
#Number of data points
Nd = [10, 100, 1000]
#Number of coefficients
Nc = [2, 3]
#Number of simulations
Nreps = 50
options = (Nsamples=2000, Nadapt=1000, delta=.8, Nd=Nd, Nc=Nc)
```

* speed

```@raw html
<img src="images/Linear_Regression/summary_time.png" width="700"/>
```

* allocations

```@raw html
<img src="images/Linear_Regression/summary_allocations.png" width="700"/>
```

* effective sample size

```@raw html
<img src="images/Linear_Regression/summary_B0_ess.png" width="700"/>
```

### Linear Ballistic Accumulator (LBA)

* Model

```math
\tau \sim TNormal(.4,.1,0,y_{min})
```
```math
A \sim TNormal(.8,.4,0,\infty)
```
```math
k \sim TNormal(.2,.3,0,\infty)
```
```math
v \sim Normal(0,3)
```
```math
(t,c) \sim LBA(A,b,v,s,\tau)
```

where

```math
t = y_i - t_{er}
```
```math
b = A + k
```
```math
s = 1
```
```math
LBA(A,b,v,s,\tau) = f_c(t)\prod_{j \neq c} (1-F_j(t))
```
```math
f_c(t) = \frac{1}{A} \left[-v_c \Phi\left( \frac{b-A-tv_c}{ts} \right) + \phi\left( \frac{b-A-tv_c}{ts} \right) +
+ v_c \Phi\left( \frac{b-tv_c}{ts} \right) + s \phi\left( \frac{b-tv_c}{ts} \right) \right]
```
```math
\begin{multline*}
 F_c(t) = 1 + \frac{b-A-tv_c}{A} \Phi\left( \frac{b-A-tv_c}{ts} \right) - \frac{b-tv_c}{A} \Phi\left( \frac{b-tv_c}{ts} \right)\\
 + \frac{ts}{A} \phi\left( \frac{b-A-tv_c}{ts} \right) - \frac{ts}{A} \phi\left( \frac{b-tv_c}{ts} \right)
 \end{multline*}
```
```math
Y = {y_1,...,y_n}
```
```math
y_{min} = minimum(Y)
```

* benchmark design

```julia
#Number of data points
Nd = [10, 50, 200]
#Number of simulations
Nreps = 50
options = (Nsamples=2000, Nadapt=1000, delta=.8, Nd=Nd)
```

* speed

```@raw html
<img src="images/LBA/summary_time.png" width="500"/>
```

* allocations

```@raw html
<img src="images/LBA/summary_allocations.png" width="500"/>
```

* effective sample size

```@raw html
<img src="images/LBA/density_A_ess.png" width="700"/>
```

### Poisson Regression

* Model

```math
a_0 \sim Normal(0,10)
```
```math
a_1 \sim Normal(0,1)
```
```math
\sigma_{a0} \sim TCauchy(0,1,0,\infty)
```
```math
a_{0i} ~ \sim Normal(0,\sigma_{a0})
```
```math
\lambda = e^{a_0 + a_{0i} + a_1*x_i}
```
```math
y_i \sim Poisson(\lambda)
```

* benchmark design

```julia
# Number of data points per unit
Nd = [1, 2, 5]
# Number of units in model
Ns = 10
# Number of simulations
Nreps = 25
options = (Nsamples=2000, Nadapt=1000, delta=.8, Nd=Nd, Ns=Ns)

```

* speed

```@raw html
<img src="images/Hierarchical_Poisson/summary_time.png" width="500"/>
```

* allocations

```@raw html
<img src="images/Hierarchical_Poisson/summary_allocations.png" width="500"/>
```

* effective sample size

```@raw html
<img src="images/Hierarchical_Poisson/density_a0_ess.png" width="500"/>
```

### Forward vs. Reverse Autodiff

* Hierarchical Poisson

* benchmark design

```julia

# Number of data points per unit
Nd = 1
# Number of units in model
Ns = [10, 20, 50]
# Number of simulations
Nreps = 20
autodiff = [:forward, :reverse]
options = (Nsamples=2000, Nadapt=1000, delta=.8, Nd=Nd, Ns=Ns, autodiff=autodiff)

```

* speed

```@raw html
<img src="images/Autodiff/summary_time.png" width="500"/>
```

* allocations

```@raw html
<img src="images/Autodiff/summary_allocations.png" width="500"/>
```

* effective sample size

```@raw html
<img src="images/Autodiff/density_a0_ess.png" width="700"/>
```
