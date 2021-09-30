

if(!require("rjags")) install.packages("rjags"); library(rjags)
if(!require("R2jags")) install.packages("R2jags"); library(R2jags)
if(!require(foreach)) install.packages("foreach"); library(foreach)
if(!require(doParallel)) install.packages("doParallel"); library(doParallel)

set.seed(12345)

# Load simulation scenarios
source("simulation_scenarios_RBasket_trial.R")

#-----------------------------------------------------------------------------------------------

simulation_replicate_bugs <- function(true.beta0, true.beta1, Module, Trt, cutoff.theta){
  
  ngroups <- length(unique(Module))
  npatients <-length(Trt)
  ntreat <- length(unique(Trt))
  
  y <- numeric(length = npatients)
  for (i in 1:npatients) {
    y[i] <- true.beta0[Module[i]] + true.beta1[Module[i]]*Trt[i] + rnorm(1, mean = 0, sd = 0.4)
  }
  
  
  inits <- function(){
    list(
      tau = rep(10, ngroups),
      sigma = 1
    )
  }
  
  s0 = 0.15; lSlab = 0.01;  uSlab = 1;  spike = 100
  prior.beta1 = rep(0, ngroups);  prior.sd.beta1 = rep(10, ngroups);  prior.mu.beta0 = c(0, 5);  prior.sig.HN = 1
  Tmodule =c(1,1,1,1,1,2,2,2,2,2); Gmodule=c(1,2,3,4,5,1,2,3,4,5)
  
  data <- list("ngroups", "npatients", "ntreat", "y", "Tmodule", "Gmodule", "Module", "Trt", "prior.beta1", "prior.sd.beta1",
               "s0", "lSlab", "uSlab", "spike","true.beta0", "prior.mu.beta0", "prior.sig.HN", "cutoff.theta")
  
  parameters <- c("theta", "pCat", "pCat2", "beta1")
  
  MCMCSim1 <- jags(data = data, inits = inits, parameters.to.save = parameters, model.file = "RandBasket_cont_data_model1.txt",
                   n.chains = 2, n.burnin = 3000, n.iter = 13000, working.directory = "C:/Users/Luke Ondijo/RBasket/code/JAGS")
  
  return(summarystats = MCMCSim1$BUGSoutput$summary)
}

#--------------------------------------------------------------------------------------------
# Specify values

Module = c(rep(1, 70), rep(2, 66), rep(3, 64), rep(4, 68), rep(5, 68))
Trt= c(rep(1, 35), rep(0, 35), rep(1, 33), rep(0, 33), rep(1, 32), rep(0, 32), 
            rep(1, 34), rep(0, 34), rep(1, 34), rep(0, 34))

cutoff.theta = c(0.25, 0.30)

# -------------------------------------------------------------------------------------------
# Run the basket trials replicates
niterations <- 10000
cores  <- detectCores()
c1     <- makeCluster(cores)
clusterExport(c1, c("simulation_replicate_bugs", "sim_scenario", "Module", "Trt", "cutoff.theta"))
clusterEvalQ(c1, library(R2jags))
clusterSetRNGStream(c1, 12345)

start = Sys.time()

pLapply_BUGS_replicates_RB_trial_mod1_scen1 <- parLapply(cl=c1, 1:niterations, function(i){ simulation_replicate_bugs(
                                                           true.beta0=sim_scenario[[1]]$true.beta0, true.beta1=sim_scenario[[1]]$beta1,Module=Module, Trt=Trt, 
                                                           cutoff.theta=cutoff.theta)})

stopCluster(c1)
stop = Sys.time()
print(paste("Run time is:", stop-start,sep=""))

# Save results as RDS file to a folder
saveRDS(BUGS_replicates_RB_trial_mod1_scen1, "results/JAGS_replicates_RB_trial_mod1_scen1")