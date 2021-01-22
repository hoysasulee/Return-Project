##################
### Exercise 1 ###
##################

n = 30; # sample size

set.seed(1);
y = rbinom(n, size = 1, prob = 0.8);
sum(y);

y_bar = mean(y);
s2    = var(y) * (n-1) / n;
s2    = s2/n;

a = y_bar*(n-1);a;
b = (n-1)*(1-y_bar);b;

# Equivalently
#a = (1-y_bar)*y_bar^2 / s2 - y_bar;a;
#b = (1-y_bar)^2 * y_bar / s2 - (1-y_bar);b;

ap = sum(y) + a;ap; # Posterior parameters
bp = n - sum(y) + b;bp;

ap/(ap+bp); # posterior mean

# Probability of the hypothesis
pbeta(2/3, shape1 = ap, shape2 = bp, lower.tail = FALSE);
1 - pbeta(2/3, shape1 = ap, shape2 = bp);

# quantiles
qbeta(c(0.025, 0.975), shape1 = ap, shape2 = bp);

pdf("post_prior_11.pdf")
par(mar = c(4,4,2,1));
x = seq(0,1,length=300);
plot(x, dbeta(x, shape1 = ap, shape2 = bp), col = "blue",
     xlim = c(0,1), type = "l", xlab = "p", ylab = "density");
curve(dbeta(x, shape1 = a, shape2 = b), 
      xlab = "p", ylab = "density", col = "black", add = TRUE);
#lines(y, 25*dbinom(sum(x), size = n, prob = y), col = "red"); # likelihood
legend("topleft",legend=c("Prior", "Posterior"), cex=.8, 
       col= c("black", "blue"), lty=1);
dev.off()

### Uniform prior ###
au = 1;
bu = 1;

apu = sum(y) + au; apu; # Posterior parameters
bpu = n - sum(y) + bu;bpu;

apu/(apu+bpu); # posterior mean

# Probability of the hypothesis
pbeta(2/3, shape1 = apu, shape2 = bpu, lower.tail = FALSE);
1 - pbeta(2/3, shape1 = apu, shape2 = bpu);

# quantiles
qbeta(c(0.025, 0.975), shape1 = apu, shape2 = bpu);

pdf("post_prior_12.pdf")
par(mar = c(4,4,2,1));
x = seq(0,1,length=300);
plot(x, dbeta(x, shape1 = apu, shape2 = bpu), col = "blue",
     xlim = c(0,1), type = "l", xlab = "p", ylab = "density");
curve(dbeta(x, shape1 = au, shape2 = bu), 
      xlab = "p", ylab = "density", col = "black", add = TRUE);
legend("topleft",legend=c("Prior", "Posterior"), cex=.8, 
       col= c("black", "blue"), lty=1);
dev.off()

##################
### Exercise 2 ###
##################

set.seed(1);
x2 = rbinom(n, size = 1, prob = 0.5);
sum(x2); mean(x2);

# previous posterior is used as prior
ap2 = sum(x2) + ap; ap2; # Posterior parameters
bp2 = n - sum(x2) + bp; bp2;

# Probability of the hypothesis
pbeta(2/3, shape1 = ap2, shape2 = bp2, lower.tail = FALSE);
1 - pbeta(2/3, shape1 = ap2, shape2 = bp2);

# Uniform used as prior
ap3 = sum(x2) + 1; ap3; # Posterior parameters
bp3 = n - sum(x2) + 1; bp3;
pbeta(2/3, shape1 = ap3, shape2 = bp3, lower.tail = FALSE);

### plots ###
pdf("post_prior_2.pdf")
par(mar = c(4,4,2,1));
plot(y, dbeta(y, shape1 = ap3, shape2 = bp3), 
     xlim = c(0,1), ylim = c(0, max(dbeta(y, shape1 = ap2, shape2 = bp2))), 
     type = "l", xlab = "p", ylab = "density");
curve(dbeta(x, shape1 = 1, shape2 = 1), 
      xlab = "p", ylab = "density", col = "blue", add = TRUE);
abline(v=0.5, lty=2)
curve(dbeta(x, shape1 = ap2, shape2 = bp2), 
      xlab = "p", ylab = "density", col = "red", add = TRUE);
curve(dbeta(x, shape1 = ap, shape2 = bp), 
      xlab = "p", ylab = "density", col = "green", add = TRUE);
legend("topleft", legend = c("Posterior 1", "Posterior 2", "Prior 1", "Prior 2"),
       col = c("red", "black", "green", "blue"), lty = 1)
axis(side = 1, at = 0.5, "0.5")
dev.off()

# Credible intervals
qbeta(c(0.025, 0.975), shape1 = ap2, shape2 = bp2);
qbeta(c(0.025, 0.975), shape1 = ap3, shape2 = bp3);




