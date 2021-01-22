drug <- read.table("~/Downloads/abDrugEffect.dat",header = TRUE, check.names = TRUE)
x = cbind(drug[drug$treatment == "1", c("treatment","score1")], 
          drug[drug$treatment == "1",c("score2")])
colnames(x) = c("treatment","score1", "score2")
g1=drug[,4]; # Drug A score
g2=drug[,5]; # Drug B score
x=cbind(g1,g2)

set.seed(1)
R = rdm_ind(g1, g2, nreps = 10000)
dev.new()
pdf("drug.pdf")
dev.new()
hist(R$resampMeanDiff, xlab = "Mean difference", freq = F,
     main = "Distribution under Null hypothesis")
mtext("drugB - drugA", 3)
text(R$diffObt, 0.3, expression(paste("obs diff",sep="")))
arrows(R$diffObt, 75, R$diffObt, 0, length = .125);
text(4, 0.2, paste("p-value= ", R$pvalue ,sep=""))


n_psc  = length(g1);   # number of observations in drugA group
n_npsc = length(g2); # number of observations in drugB group

N = 1000; # number ofbootstrap samples
out = NULL; # number of bootstrap samples

for(i in 1:N){
  
  b_psc  = sample(1:n_psc, n_psc, replace = TRUE);
  b_npsc = sample(1:n_npsc, n_npsc, replace = TRUE);
  
  out = c(out, mean(g2[b_npsc]) - mean(g2[b_psc]));
  
}

dev.new()
hist(out,main = "Bootstrap sample",xlab ="p_hat");

round(quantile(out, probs = c(0.025,0.975)), 4);# bootstrap confidence interval

Ax=drug[drug$treatment == "1", "score1"];
Ay=drug[drug$treatment == "1", "score2"];
Bx=drug[drug$treatment == "2", "score1"];
By=drug[drug$treatment == "2", "score2"];

y = c(Ay,By) 
x = c(Ax,Bx)

n = length(y);

f = c(rep("A", length(Ax)), rep("B", length(Bx))); # factor
f = as.factor(f);

fit = lm(y ~ x + f); # linear model

dev.new()
plot(x,y); 
plot(fit);

summary(fit);

anova(fit);

### Randomization test ####

B   = 10000;
out = NULL;

set.seed(1)
for(i in 1:B){
  
  b     = sample(1:n, n, replace = FALSE);
  
  bfit  = lm(y[b] ~ x[b] + f);
  
  out   = c(out, summary(bfit)$coefficients[3,1]);
  
}

obs = summary(fit)$coefficients[3,1];
pvalue = (sum(abs(obs) <= out) + sum(-abs(obs)>=out)) / B;
pvalue

pdf("food_AB.pdf")
par(mar=c(4,4,3,1));
dev.new()
hist(out, xlab = expression(beta[compB]),
     main = "Distribution under Null hypothesis", freq = F);
obs = summary(fit)$coefficients[3,1];
text(obs, 0.39, expression(paste("obs ", beta[compB]),sep=""));
arrows(obs, 0.38, obs, 0, length = .125);
text(2.5, .3, paste("p-value= ", pvalue ,sep=""));
dev.off()


B   = 10000;
out = NULL;

for(i in 1:B){
  
  b     = sample(1:n, n, replace = TRUE);
  
  f1    = relevel(f[b], "A"); # A as baseline
  bfit  = lm(y[b] ~ x[b] + f1);
  
  out   = rbind(out, summary(bfit)$coefficients[3,1]);
  
}

# This CI contains 0, which is in agreement with randomization test
round(quantile(out, prob = c(0.025, 0.975)), 3); # bootstrap CI
dev.new()
hist(out, xlab = "Difference in average");
text(1.5, 2400, expression(paste("obs ", beta[compB]),sep=""));
arrows(obs, 2500, obs, 0, length = .125);
text(4, 1500, paste("p-value= ", pvalue ,sep=""));
abline(v = obs, lty = 2); 

