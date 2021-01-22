y <- read.csv("~/Downloads/cavendish.txt", sep="")
x <- y$Density;
n = length(x);
xbar = mean(x);

pdf("sun_hist.pdf")
par(mar=c(4,4,3,1))
dev.new()
hist(x, freq=F, main = "The density of the earth",
     xlab = "X");

mu_prior = 0;
sigma_prior = 0.19;
(mu_prior/sigma_prior)^(-1)

# Posterior parameters
mu_post = (n*xbar)/((n/xbar^2)+(1/sigma_prior^2));
sigma_post = ((n/xbar^2)+(1/sigma_prior^2))^-1/2;
(mu_post/sigma_post)^(-1)

# credible interval
round(qnorm(c(0.025, 0.975), mean=mu_post, sd=sigma_post),4);

pdf("cavendish.pdf")
par(mar=c(100,100,1,1))
dev.new()
curve(dnorm(x, mean=mu_post, sd=sigma_post), col = "blue",
      ylab = "Density")
curve(dnorm(x, mean = mu_prior, sd = sigma_prior), add=T, col="red")
legend("topright", legend = c("Prior", "Posterior"),
       col = c("red", "blue"), lty = 1)
dev.off()

# credible interval
round(qnorm(c(0.025, 0.975), mean=mu_post, sd=sigma_post),3);
pdf("sunspot_expX.pdf")
par(mar=c(4,4,2,1))
dev.new()
curve(dnorm(x, mean = mu_prior, sd = sigma_prior), xlim=c(60,100),
      xlab = expression(paste("E(X)=1/",lambda, sep = "")),
      ylab = "Density", main = "Expected value of X distribution");
dev.off()
