library(mvtnorm)

mh = function(n, mu, sigma, starting_value, step){

  current_value  = starting_value;
  current_den    = dmvnorm(current_value, mean=mu, sigma=sigma, log=TRUE);
  proposal_value = current_value;

  out   = NULL; # to store output
  step1 = step[1]; # proposal step lengths - First component
  step2 = step[2]; # proposal step lengths - Second component

  for(i in 1:n){
  
    ### updating first component ###
  
    proposal_value[1] = runif(1, current_value[1] - step1, current_value[1] + step1);
  
    proposal_den = dmvnorm(proposal_value, mean=mu, sigma=sigma, log=TRUE);
  
    alpha = proposal_den - current_den;
  
    u     = -rexp(1); # equivalent to log(runif(1))
  
    if(u <= alpha){
    
      current_value[1] = proposal_value[1];
      current_den      = proposal_den;
    
    }else{
    
      proposal_value[1] = current_value[1]; # reset proposal
    
    }
  
    ### updating second component ###
  
    proposal_value[2] = runif(1, current_value[2] - step2, current_value[2] + step2);
  
    proposal_den = dmvnorm(proposal_value, mean=mu, sigma=sigma, log = TRUE);
  
    alpha = proposal_den - current_den;
  
    u     = -rexp(1); # equivalent to log(runif(1))
  
    if(u <= alpha){
    
      current_value[2] = proposal_value[2];
      current_den      = proposal_den;
    
    }else{
    
      proposal_value[2] = current_value[2]; # reset proposal
    }
  
    out = rbind(out, current_value);
  }

  rownames(out) = NULL;
  
  return(out);
}

### RUN ###

n     = 2000; # sample size
mu    = c(1,2);
rho   = 0.0;
s1    = 2;
s2    = 3;
s12   = s1 * s2 * rho;
sigma = matrix(c(s1^2, s12, s12, s2^2), ncol=2);

##############
### case 1 ###
##############

set.seed(1)
R1 = mh(n, mu, sigma, starting_value = c(1,1), step = c(4,5))


pdf("lab2_case1.pdf", width = 14, height = 3.5)
layout(matrix(c(1,3,4,5,2,3,4,5), 2, 4, byrow = TRUE))
par(mar= c(4,4,2,1))
plot(R1[,1], type = "l", xlab = "", ylab = "");
mtext("Iteration", side = 1, line = 2.5);
mtext(expression(X[1]), side = 2, line = 2.5);

plot(R1[,2], type = "l", xlab = "", ylab = "");
mtext("Iteration", side = 1, line = 2.5);
mtext(expression(X[1]), side = 2, line = 2.5);

plot(R1[,1], R1[,2], main = "", xlab = "", ylab = "");
mtext(expression(X[1]), side = 1, line = 2.5);
mtext(expression(X[2]), side = 2, line = 2.5);

hist(R1[,1], freq = FALSE, xlab ="", main = ""); curve(dnorm(x, mean=mu[1], sd =s1), add = TRUE);
mtext(expression(X[1]), side = 1, line = 2.5);

hist(R1[,2], freq = FALSE, xlab = "", main = ""); curve(dnorm(x, mean=mu[2], sd =s2), add = TRUE)
mtext(expression(X[2]), side = 1, line = 2.5);
dev.off()

coda::effectiveSize(R1[,1])
coda::effectiveSize(R1[,2])

##############
### case 2 ###
##############

rho   = 0.9;
s12   = s1 * s2 * rho;
sigma = matrix(c(s1^2, s12, s12, s2^2), ncol=2);

set.seed(1)
R2 = mh(n, mu, sigma, starting_value = c(1,1), step = c(4,5))

pdf("lab2_case2.pdf", width = 14, height = 3.5)
layout(matrix(c(1,3,4,5,2,3,4,5), 2, 4, byrow = TRUE))
par(mar= c(4,4,2,1))
plot(R2[,1], type = "l", xlab = "", ylab = "");
mtext("Iteration", side = 1, line = 2.5);
mtext(expression(X[1]), side = 2, line = 2.5);

plot(R2[,2], type = "l", xlab = "", ylab = "");
mtext("Iteration", side = 1, line = 2.5);
mtext(expression(X[1]), side = 2, line = 2.5);

plot(R2[,1], R2[,2], main = "", xlab = "", ylab = "");
mtext(expression(X[1]), side = 1, line = 2.5);
mtext(expression(X[2]), side = 2, line = 2.5);

hist(R2[,1], freq = FALSE, xlab ="", main = ""); curve(dnorm(x, mean=mu[1], sd =s1), add = TRUE);
mtext(expression(X[1]), side = 1, line = 2.5);

hist(R2[,2], freq = FALSE, xlab = "", main = ""); curve(dnorm(x, mean=mu[2], sd =s2), add = TRUE)
mtext(expression(X[2]), side = 1, line = 2.5);
dev.off()

coda::effectiveSize(R2[,1])
coda::effectiveSize(R2[,2])

# 2000 samples using thining factor = 10
set.seed(1)
R3 = mh(n = 20000, mu, sigma, starting_value = c(1,1), step = c(4,5));
R3 = R3[seq(1,20000, by = 10),];

pdf("lab2_case2_1.pdf", width = 14, height = 3.5)
layout(matrix(c(1,3,4,5,2,3,4,5), 2, 4, byrow = TRUE))
par(mar= c(4,4,2,1))
plot(R3[,1], type = "l", xlab = "", ylab = "");
mtext("Iteration", side = 1, line = 2.5);
mtext(expression(X[1]), side = 2, line = 2.5);

plot(R3[,2], type = "l", xlab = "", ylab = "");
mtext("Iteration", side = 1, line = 2.5);
mtext(expression(X[1]), side = 2, line = 2.5);

plot(R3[,1], R3[,2], main = "", xlab = "", ylab = "");
mtext(expression(X[1]), side = 1, line = 2.5);
mtext(expression(X[2]), side = 2, line = 2.5);

hist(R3[,1], freq = FALSE, xlab ="", main = ""); curve(dnorm(x, mean=mu[1], sd =s1), add = TRUE);
mtext(expression(X[1]), side = 1, line = 2.5);

hist(R3[,2], freq = FALSE, xlab = "", main = ""); curve(dnorm(x, mean=mu[2], sd =s2), add = TRUE)
mtext(expression(X[2]), side = 1, line = 2.5);
dev.off()

coda::effectiveSize(R3[,1]);
coda::effectiveSize(R3[,2]);

#########################
### mvtnormal example ###
#########################

x = rmvnorm(n, mean = mu, sigma = sigma);

plot(x[,1], x[,2])
plot(x[,1], type = "l")
plot(x[,2], type = "l")

coda::effectiveSize(x[,1])
coda::effectiveSize(x[,2])

### my multivariate normal ###

f = function(x, mu, sigma){
  
  dif = x - mu;

  aux1 = - 0.5 * dif %*% solve(sigma) %*% dif;

  aux2 = - 0.5 * (length(x) * log(2* pi) + log(det(sigma)) );
  
  return(aux1 + aux2);
  
}

f(current_value, mu, sigma)
