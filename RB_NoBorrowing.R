
if(!require("rjags")) install.packages("rjags"); library(rjags)
if(!require("R2jags")) install.packages("R2jags"); library(R2jags)
if(!require(foreach)) install.packages("foreach"); library(foreach)
if(!require(doParallel)) install.packages("doParallel"); library(doParallel)

set.seed(12345)

simulation_replicate_bugs <- function(true.beta0, true.theta, Module, true.Trt, cutoff.theta){
  
  ngroups <- length(unique(Module))
  npatients <-length(true.Trt)
  ntreat <- length(unique(true.Trt))
  
  y.true <- numeric(length = npatients)
  for (i in 1:npatients) {
    y.true[i] <- true.beta0[Module[i]] + true.theta[Module[i]]*true.Trt[i] + rnorm(1, mean = 0, sd = 0.4)
  }
  
  inits <- function(){
    list(
      tau = 10
    )
  }
  
  prior.theta = 0;  prior.sd.theta = 10;  prior.mu.beta0 = c(0, 5)
  
  data <- list("npatients", "y", "Trt", "prior.theta", "prior.sd.theta","prior.mu.beta0", "cutoff.theta")
  
  parameters <- c("theta", "pCat", "pCat2")
  
  nthetaM = numeric(ngroups)
  npCatM = numeric(ngroups)
  npCat2M = numeric(ngroups)
  nthetaSD = numeric(ngroups)
  nlowCI = numeric(ngroups)
  nupperCI = numeric(ngroups)
  
  for(k in 1:ngroups){
    y = y.true[Module == k]
    npatients = length(y)
    Trt = true.Trt[Module == k]
    
    MCMCSim2 <- jags(data = data, inits = inits, parameters.to.save = parameters, model.file = "NoBorrowing.txt", 
                     n.chains = 2, n.burnin = 3000, n.iter = 13000,
                     working.directory = "C:/Users/Luke Ondijo/RBasket/code/JAGS")
    
    nthetaM[k] = MCMCSim2$BUGSoutput$mean$theta
    npCatM[k] = MCMCSim2$BUGSoutput$mean$pCat
    npCat2M[k] = MCMCSim2$BUGSoutput$mean$pCat2 
    nthetaSD[k]= MCMCSim2$BUGSoutput$sd$theta
    nlowCI[k]= MCMCSim2$BUGSoutput$summary[c("theta"),c("2.5%")]
    nupperCI[k]= MCMCSim2$BUGSoutput$summary[c("theta"),c("97.5%")]
    
  }
  nlowupperCI =cbind(nlowCI, nupperCI)
  return(summarystats=list(nthetaM,npCatM,npCat2M,nthetaSD,nlowupperCI))
}

# Load simulation scenarios
source("simulation_scenarios_RBasket_trial.R")

# Specify values
Module = c(rep(1, 70), rep(2, 66), rep(3, 64), rep(4, 68), rep(5, 68))
true.Trt= c(rep(1, 35), rep(0, 35), rep(1, 33), rep(0, 33), rep(1, 32), rep(0, 32), 
       rep(1, 34), rep(0, 34), rep(1, 34), rep(0, 34))

cutoff.theta = c(0.25, 0.30)

niterations <- 10000
cores  <- detectCores()
c1     <- makeCluster(cores)
clusterExport(c1, c("simulation_replicate_bugs", "sim_scenario", "Module", "true.Trt", "cutoff.theta"))
clusterEvalQ(c1, library(R2jags))
clusterSetRNGStream(c1, 12345)

start = Sys.time()

pLapply_noborrowing_scen1 <- parLapply(cl=c1, 1:niterations, function(i){simulation_replicate_bugs(
  true.beta0=sim_scenario[[1]]$true.beta0,true.theta=sim_scenario[[1]]$beta1,Module=Module, true.Trt=true.Trt, 
  cutoff.theta=cutoff.theta)})

stopCluster(c1)
stop = Sys.time()
print(paste("Run time is:", stop-start,sep=""))

# Save results as RDS file to a folder
saveRDS(pLapply_noborrowing_scen1, "results/pLapply_noborrowing_scen1")
