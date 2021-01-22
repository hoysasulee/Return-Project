N = 10000; # number of samples

current_value = 1; # starting value
current_den   = dgamma(current_value, shape = 9, rate = 2, log = TRUE);
sigma         = 1; # proposal length
out   = NULL; # to store samples
count = NULL; # to count the number of proposals accepted

for(i in 1:N){
  
  proposal_value = rnorm(1, mean = current_value, sd = sigma);
  proposal_den   = dgamma(proposal_value, shape = 9, rate = 2, log = TRUE);
  
  alpha = proposal_den - current_den; # log-acceptance pbb
  
  u = log(runif(1)); # = - rexp(1, rate = 1)
  
  if(u <= alpha){
    
    current_value = proposal_value;
    current_den   = proposal_den;
    count = c(count, 1);
    
  }else{
    
    count = c(count, 0);
    
  }
  
  if(mean(count) > 0.4){ 
    
    sigma = sigma * 1.1;
    
  }else if(mean(count) < 0.3){
    
    sigma = sigma * 0.9;
    
  }
  
  out = c(out, current_value);
  
} # end for

### 1 ###
sigma; # proposal steps

### 2 ###
pdf("lab1_traceplot.pdf", width = 12, height = 3.5)
par(mar = c(4,4,2,1))
plot(out, type = "l", xlab="Iteration", ylab = "X",
     main = "Trace plot")
dev.off()

### 3 ###
x = out[seq(1,N, by=5)]; # thining factor

### 4 ###
pdf("lab1_hist.pdf")
par(mar = c(4,4,2,1))
hist(x, freq = FALSE, ylim = c(0, max(dgamma(x, shape=9, rate=2))),
     main = "Gamma distribution"); 
curve(dgamma(x, shape = 9, rate = 2), add=TRUE);
dev.off()

### 5 ###
pdf("lab1_acceptanceRate.pdf")
par(mar = c(4,4,2,1))
plot(cumsum(count)/(1:N), type = "l", ylab = "Acceptance rate", 
     xlab = "Iteration");
abline(h = 0.3, lty = 2);
abline(h = 0.4, lty = 2);
mtext(paste("Mean = ", mean(count)), side = 3)
dev.off()

### 6 ###

round(mean(x), 2); # sample mean
9/2; # true value

round(mean((x - mean(x))^2), 2); # Sample variance
9/2^2; # true variance

### Post analysis with coda package ###
library(coda)

y.mcmc = mcmc(out);
summary(y.mcmc);
plot(y.mcmc)

effectiveSize(y.mcmc);
acceptance_rate = 1-rejectionRate(y.mcmc);
acceptance_rate;
