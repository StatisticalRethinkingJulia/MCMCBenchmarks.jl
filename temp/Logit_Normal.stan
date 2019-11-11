data {
      int N;
      int Nsub;
      int y[Nsub];
}

parameters {
      real mu;
      real<lower=0> sigma;
      vector[Nsub] a;
}

model {
      real theta;
      mu ~ normal(0, .5);
      sigma ~ exponential(3);
      a ~ normal(mu,sigma);
      // theta = logit(a);
      y ~ binomial_logit(N, a);
}
