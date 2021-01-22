y <- read.table("~/Downloads/SN_y_tot_V2.0.txt", quote="\"", comment.char="")
x = y$V2;
n = length(x);
xbar = mean(x);
#View(x);
#ts.plot(x);

pdf("sun_hist.pdf")
par(mar=c(4,4,3,1))
dev.new()
hist(x, freq=F, main = "Yearly mean total sunspot number [1700 - now]",
     xlab = "X");
dev.off()

# Prior parameters
a_prior = 0.001;
b_prior = 0.1;
(a_prior/b_prior)^(-1)

# Posterior parameters
a_post = n + a_prior;
b_post = n*xbar + b_prior;
(a_post/b_post)^(-1)

pdf("sunspot_by_distbs.pdf")
par(mar=c(4,4,1,1))
dev.new()
curve(dgamma(x, shape = a_post, rate = b_post), col = "blue",
      ylab = "Density")
curve(dgamma(x, shape = a_prior, rate = b_prior), add=T, col="red")
legend("topright", legend = c("Prior", "Posterior"),
       col = c("red", "blue"), lty = 1)
dev.off()

# credible interval
round(qgamma(c(0.025, 0.975), shape = a_post, rate = b_post),3);


library(invgamma)
round(invgamma::qinvgamma(c(0.025, 0.975), shape=a_post, rate=b_post), 3);

pdf("sunspot_expX.pdf")
par(mar=c(4,4,2,1))
dev.new()
curve(invgamma::dinvgamma(x, shape=a_post, rate=b_post), xlim=c(60,100),
      xlab = expression(paste("E(X)=1/",lambda, sep = "")),
      ylab = "Density", main = "Expected value of X distribution");
dev.off()

# Posterior predictive distribution

aux = seq(0.01,200, length = 1000)
pdf = (b_post^a_post / gamma(a_post)) * 
      (gamma(a_post + 1) / (aux + b_post)^(a_post + 1))

lpdf = a_post*log(b_post) - lgamma(a_post) + 
       lgamma(a_post + 1) - (a_post + 1)*log(aux + b_post);
dev.new()
plot(aux, exp(lpdf), type ="l", main="Predictive posterior distribution",
     ylab = "Density", xlab = expression(Y[new]));
