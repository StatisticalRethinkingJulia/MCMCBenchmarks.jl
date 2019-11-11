functions{

    real LNR_LL(vector mus,real sigma,real ter,real v,int c){
      real LL;
      LL = 0;
      for(i in 1:num_elements(mus)){
        if(i == c){
          LL += lognormal_lpdf(v-ter|mus[i],sigma);
      }else{
        LL += log(1-lognormal_cdf(v-ter,mus[i],sigma));
      }
    }
      return LL;
    }

}

data{
     int N;
     int Nr;
     vector[N] rt;
     int choice[N];
}

parameters {
     vector[Nr] mu;
     real<lower=0> sigma;
}

model {
     mu ~ normal(0, 3);
     sigma ~ cauchy(0,1);
     for(i in 1:N){
         target += LNR_LL(mu, sigma, 0.0, rt[i], choice[i]);
      }
}
