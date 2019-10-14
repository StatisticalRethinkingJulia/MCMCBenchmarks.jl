## Benchmark Results
In this section, we report key benchmark results comparing Turing, CmdStan, and DynamicHMC for a variety of models. The code for each of the benchmarks can be found in the Examples folder, including corresponding code for the models in folder named Models. The benchmarks were performed with the following software and hardware:

* Julia 1.1.1
* CmdStan 5.1.1
* Turing 0.6.23
* DynamicHMC 1.0.6
* Ubuntu 18.04
* Intel(R) Core(TM) i7-4790K CPU @ 4.00GHz

Before proceeding to the results, a few caveates should be noted. (1) Turing and DynamicHMC are under active development. Consequentially, their performance may improve over time. (2) Memory allocations and garbage collection time is not applicable for CmdStan because the heavy lifting is performed in C++. (3) Performance scaling is poor for Turing and DynamicHMC because they use forward mode autodifferentiation where as CmdStan uses reverse mode autodifferentiation.

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
<img src="images/Gaussian/density_mu_ess.png" width="500"/>
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
Nd = [10, 100, 1000]
#Number of simulations
Nreps = 100
options = (Nsamples=2000, Nadapt=1000, delta=.8, Nd=Nd)
```

* speed
* allocations
* effective sample size

### Linear Regression

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

* speed
* allocations
* effective sample size

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
y_{min} = /textrm{minimum}(Y)
```

* benchmark design
* speed
* allocations
* effective sample size

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
#Number of data points per unit
Nd = [1,2,5]
#Number of units in model
Ns = 10
#Number of simulations
Nreps = 25
options = (Nsamples=2000, Nadapt=1000, delta=.8, Nd=Nd, Ns=Ns)
```

* speed
* allocations
* effective sample size
