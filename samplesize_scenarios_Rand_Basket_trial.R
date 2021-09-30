# These are subtrial sample sizes for which we evaluate the performance of treatment arm and treatment effect borrowing 

# Sample size scenario 1 is scenario with small sample size
# Sample size scenario 2 is scenario with relatively large sample size

RBssize_scenario <- list(ssize_scen1 =list(Module = c(rep(1, 12), rep(2, 18), rep(3, 10), rep(4, 16), rep(5, 14)), 
                                           Trt= c(rep(1, 6), rep(0, 6), rep(1, 9), rep(0, 9), rep(1, 5), rep(0, 5), 
                                                  rep(1, 8), rep(0, 8), rep(1, 7), rep(0, 7))),
                         ssize_scen2 =list(Module = c(rep(1, 100), rep(2, 100), rep(3, 106), rep(4, 110), rep(5, 104)),
                                           Trt= c(rep(1, 50), rep(0, 50), rep(1, 50), rep(0, 50), rep(1, 53), rep(0, 53), 
                                                  rep(1, 55), rep(0, 55), rep(1, 52), rep(0, 52))))
