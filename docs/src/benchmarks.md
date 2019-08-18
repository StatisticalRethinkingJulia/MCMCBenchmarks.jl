## Benchmark Results

* speed
* allocations
* effective sample size

### Gaussian

* Model

```math
\mu \sim Normal(0,1)
\sigma \sim TCauchy(0,5,0,\infty)
Y \sim Normal(\mu,\sigma)
```

* benchmark design

* speed
* allocations
* effective sample size

### Signal Detection Theory

* Model

```math
d \sim Normal(0,1/\sqrt(2))
c \sim Normal(0,1/\sqrt(2))

\theta_{hits} = ϕ(d/2-c)
\theta_{fas} = ϕ(-d/2-c)

n_{hits} \sim Normal(\mu,\theta_{hits})
n_{fas} \sim Binomial(N,\theta_{fas})
```

* benchmark design

* speed
* allocations
* effective sample size

### Linear Regression


* Model

```math
\mu \sim Normal(0,1)
\sigma \sim TCauchy(0,5,0,\infty)
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
f_c(t) = \fract{1}{A} \left[-v_c \Phi\left( \fract{b-A-tv_c}{ts} \right) + \phi\left( \fract{b-A-tv_c}{ts} \right) +
+ v_c \Phi\left( \fract{b-tv_c}{ts} \right) + s \phi\left( \fract{b-tv_c}{ts} \right) \right]
```
```math
F_c(t) = 1 + \fract{b-A-tv_i}{A}  \Phi\left \fract{b-A-tv_c}{ts} \right) - \fract{b-tv_i}{A}  \Phi\left \fract{b-tv_c}{ts} \right) + \fract{ts}{A} \phi \left(\fract{b-A-tv_c}{ts} \right) - \fract{ts}{A} \phi \left(\fract{b-tv_c}{ts} \right)
```
```math
Y = {y_1,...,y_n}
```
```math
y_{min} = min{Y}
```

* benchmark design

* speed
* allocations
* effective sample size

### Poisson Regression


* Model

```math
a_0 \sim Normal(0,10)
a_1 \sim Normal(0,1)
\sigma_{a0} \sim TCauchy(0,1,0,\infty)
a_{0i} ~ \sim Normal(0,\sigma_{a0})
\lambda = e^(a_0 + a_{0i} + a_1*x_i)
y_i \sim Poisson(\lambda)
```

* benchmark design

* speed
* allocations
* effective sample size
