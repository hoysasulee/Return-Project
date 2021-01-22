gibbs = function(n, mu1, mu2, s1, s2, rho, x0){
  
  x1_0 = x0[1];
  x2_0 = x0[2];

  out = NULL;
  
  for(i in 1:n){
  
    x1_0 = rnorm(1, mean = mu1 + rho * s1 * (x2_0 - mu2) / s2, 
               sd = sqrt((1-rho^2) * s1^2));
  
    x2_0 = rnorm(1, mean = mu2 + rho * s2 * (x1_0 - mu1) / s1, 
               sd = sqrt((1-rho^2) * s2^2));
    
    out = rbind(out, c(x1_0, x2_0));
  
  }
  
  return(out);
  
}  
# Specifications
n     = 2000; # sample size
mu    = c(1,2);
rho   = 0.0;
s1    = 2;
s2    = 3;

##############
### case 1 ###
##############

set.seed(1)
R1 = gibbs(n = 2000, mu1 = mu[1], mu2 = mu[2], s1 = s1, s2 = s2, 
           rho = rho, x0  = c(1,1));

pdf("lab2_case1_gibbs.pdf", width = 14, height = 3.5)
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

set.seed(1)
R2 = gibbs(n = 2000, mu1 = mu[1], mu2 = mu[2], s1 = s1, s2 = s2, 
           rho = 0.9, x0  = c(1,1));

pdf("lab2_case2_gibbs.pdf", width = 14, height = 3.5)
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

hist(R2[,1], freq = FALSE, xlab ="", main = "", ylim=c(0,dnorm(mu[1],mu[1],s1))); 
curve(dnorm(x, mean=mu[1], sd =s1), add = TRUE);
mtext(expression(X[1]), side = 1, line = 2.5);

hist(R2[,2], freq = FALSE, xlab = "", main = "", ylim=c(0,dnorm(mu[2],mu[2],s2))); 
curve(dnorm(x, mean=mu[2], sd =s2), add = TRUE)
mtext(expression(X[2]), side = 1, line = 2.5);
dev.off()

coda::effectiveSize(R2[,1])
coda::effectiveSize(R2[,2])

