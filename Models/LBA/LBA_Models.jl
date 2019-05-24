@model lbaModel(data,N,Nc) = begin
    mn=minimum(x->x[2],data)
    tau ~ TruncatedNormal(.4,.1,0.0,mn)
    A ~ TruncatedNormal(.8,.4,0.0,Inf)
    k ~ TruncatedNormal(.2,.3,0.0,Inf)
    v = Vector{Real}(undef,Nc)
    v ~ [Normal(0,3)]
    for i in 1:N
        data[i] ~ LBA(;ν=v,τ=tau,A=A,k=k)
    end
end

function AHMClba(choice,rt,N,Nc)
    data=[(c,r) for (c,r) in zip(choice,rt)]
    return lbaModel(data,N,Nc)
end

AHMCconfig = Turing.NUTS(2000,1000,.85)

DNlba(choice,rt,N,Nc)=AHMClba(choice,rt,N,Nc)

DNconfig = DynamicNUTS(2000)

CmdStanLBA = "
functions{

     real lba_pdf(real t, real b, real A, real v, real s){
          //PDF of the LBA model

          real b_A_tv_ts;
          real b_tv_ts;
          real term_1;
          real term_2;
          real term_3;
          real term_4;
          real pdf;

          b_A_tv_ts = (b - A - t*v)/(t*s);
          b_tv_ts = (b - t*v)/(t*s);
          term_1 = v*Phi(b_A_tv_ts);
          term_2 = s*exp(normal_lpdf(b_A_tv_ts|0,1));
          term_3 = v*Phi(b_tv_ts);
          term_4 = s*exp(normal_lpdf(b_tv_ts|0,1));
          pdf = (1/A)*(-term_1 + term_2 + term_3 - term_4);

          return pdf;
     }

     real lba_cdf(real t, real b, real A, real v, real s){
          //CDF of the LBA model

          real b_A_tv;
          real b_tv;
          real ts;
          real term_1;
          real term_2;
          real term_3;
          real term_4;
          real cdf;

          b_A_tv = b - A - t*v;
          b_tv = b - t*v;
          ts = t*s;
          term_1 = b_A_tv/A * Phi(b_A_tv/ts);
          term_2 = b_tv/A   * Phi(b_tv/ts);
          term_3 = ts/A     * exp(normal_lpdf(b_A_tv/ts|0,1));
          term_4 = ts/A     * exp(normal_lpdf(b_tv/ts|0,1));
          cdf = 1 + term_1 - term_2 + term_3 - term_4;

          return cdf;

     }

     real lba_lpdf(matrix RT, real k, real A, vector v, real s, real tau){

          real t;
          real b;
          real cdf;
          real pdf;
          vector[rows(RT)] prob;
          real out;
          real prob_neg;

          b = A + k;
          for (i in 1:rows(RT)){
               t = RT[i,1] - tau;
               if(t > 0){
                    cdf = 1;

                    for(j in 1:num_elements(v)){
                         if(RT[i,2] == j){
                              pdf = lba_pdf(t, b, A, v[j], s);
                         }else{
                              cdf = (1-lba_cdf(t, b, A, v[j], s)) * cdf;
                         }
                    }
                    prob_neg = 1;
                    for(j in 1:num_elements(v)){
                         prob_neg = Phi(-v[j]/s) * prob_neg;
                    }
                    prob[i] = pdf*cdf;
                    prob[i] = prob[i]/(1-prob_neg);
                    if(prob[i] < 1e-10){
                         prob[i] = 1e-10;
                    }

               }else{
                    prob[i] = 1e-10;
               }
          }
          out = sum(log(prob));
          return out;
     }
}

data{
     int N;
     int Nc;
     vector[N] rt;
     vector[N] choice;
}

parameters {
     real<lower=0> k;
     real<lower=0> A;
     real<lower=0> tau;
     vector<lower=0>[Nc] v;
}

model {
     real s;
     matrix[N,2] RT;
     s=1;
     RT[:,1] = rt;
     RT[:,2] = choice;
     k ~ normal(.5,1)T[0,];
     A ~ normal(.5,1)T[0,];
     tau ~ normal(.5,.5)T[0,];
     for(n in 1:Nc){
          v[n] ~ normal(2,1)T[0,];
     }
     RT ~ lba(k,A,v,s,tau);
}
"

CmdStanConfig = Stanmodel(name = "CmdStanLBA",model=CmdStanLBA,nchains=1,
   Sample(num_samples=2000,num_warmup=1000,adapt=CmdStan.Adapt(delta=0.8),
   save_warmup = false))

   struct LBAProb{T}
      data::T
      N::Int
      Nc::Int
  end

  function (problem::LBAProb)(θ)
      @unpack data=problem
      @unpack v,A,k,tau=θ
      d=LBA(ν=v,A=A,k=k,τ=tau)
      logpdf(d,data)+sum(logpdf.(TruncatedNormal(0,3,0,Inf),v)) +
      logpdf(TruncatedNormal(.8,.4,0,Inf),A)+logpdf(TruncatedNormal(.2,.3,0,Inf),k)+
      logpdf(TruncatedNormal(.4,.1,0,Inf),tau)
  end

function sampleDHMC(choice,rt,N,Nc,nsamples)
    data = [(c,r) for (c,r) in zip(choice,rt)]
    return sampleDHMC(data,N,Nc,nsamples)
end

# Define problem with data and inits.
function sampleDHMC(data,N,Nc,nsamples)
    p = LBAProb(data,N,Nc)
    p((v=fill(.5,Nc),A=.8,k=.2,tau=.4))
    # Write a function to return properly dimensioned transformation.
    problem_transformation(p::LBAProb) =
    as((v=as(Array,asℝ₊,Nc),A=asℝ₊,k=asℝ₊,tau=asℝ₊))
    # Use Flux for the gradient.
    P = TransformedLogDensity(problem_transformation(p), p)
    ∇P = LogDensityRejectErrors(ADgradient(:ForwardDiff, P));
    # FSample from the posterior.
    chain, NUTS_tuned = NUTS_init_tune_mcmc(∇P, nsamples);
    # Undo the transformation to obtain the posterior from the chain.
    posterior = TransformVariables.transform.(Ref(problem_transformation(p)), get_position.(chain));
    # Set varable names, this will be automated using θ
    parameter_names = ["v[1]","v[2]","v[3]","A","k","tau"]
    # Create a3
    Np = Nc+3
    a3d = Array{Float64,3}(undef,nsamples,Np,1)
    for i in 1:nsamples
        temp = Float64[]
        for p in posterior[i]
            push!(temp,values(p)...)
        end
        a3d[i,:,1] = temp'
    end
    chns = MCMCChains.Chains(a3d,parameter_names,
    Dict(
        :parameters => parameter_names,
        )
    )
    return chns
end

function simulateLBA(;Nd,v=[1.0,1.5,2.0],A=.8,k=.2,tau=.4,kwargs...)
    return (rand(LBA(ν=v,A=A,k=k,τ=tau),Nd)...,N=Nd,Nc=length(v))
end
