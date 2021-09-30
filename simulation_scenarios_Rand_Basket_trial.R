# Simulation scenarios

# 'True' treatment effect
beta1_1 = c(0, 0, 0, 0, 0)
beta1_2 = c(0.35, 0.35, 0.35, 0.35, 0.35)
beta1_3 = c(0.55, 0.55, 0.55, 0.55, 1.20)
beta1_4 = c(0.80, 0.80, 0.80, 0.80, 0.80)
beta1_5 = c(1.32, 0.72, 0.66, 0.41, 0.72)
beta1_6 = c(0.73, 1.07, 0.73, 0.46, 1.16)
beta1_7 = c(1.32, 0.72, 0.66, 0.41, 0.72)
beta1_8 = c(0, 0, 0, 0, 0)
beta1_9 = c(0, 0, 0.15, 0.87, 1.86)

# Groupwise mean response in control arm
true.beta0_1 = rep(5, 5) 
true.beta0_2 = rep(5, 5)  
true.beta0_3 = rep(5, 5)
true.beta0_4 = c(5,5,5,5,10) 
true.beta0_5 = rep(5, 5)
true.beta0_6 = rep(5, 5)
true.beta0_7 = c(3.5, 5.0, 4.2, 6.5, 5.6)
true.beta0_8 = c(2.5, 4.0, 5.5, 7.0, 5.8) 
true.beta0_9 = c(5,5,5,5,5) 

sim_scenario <- list(scenario1 = list(true.beta0 =true.beta0_1, beta1= beta1_1),
                     scenario2 = list(true.beta0 =true.beta0_2, beta1= beta1_2),
                     scenario3 = list(true.beta0 =true.beta0_3, beta1= beta1_3),
                     scenario4 = list(true.beta0 =true.beta0_4, beta1= beta1_4),
                     scenario5 = list(true.beta0 =true.beta0_5, beta1= beta1_5),
                     scenario6 = list(true.beta0 =true.beta0_6, beta1= beta1_6),
                     scenario7 = list(true.beta0 =true.beta0_7, beta1= beta1_7),
                     scenario8 = list(true.beta0 =true.beta0_8, beta1= beta1_8),
                     scenario9 = list(true.beta0 =true.beta0_9, beta1= beta1_9))