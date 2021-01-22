drug <- read.table("~/Downloads/abDrugEffect.dat",header = TRUE, check.names = TRUE)
s1=drug[,4]; # Drug A score
s2=drug[,5]; # Drug B score
s=cbind(s1,s2)
data=s
plot(s1, s2, col="red");

rdm_ind = function(s1, s2, nreps){
  # Randomization test for independent samples
  n1 = length(s1); # group 1 size
  n2 = length(s2); # group 2 size
  n = n1+n2; # total number of observations
  diffObt = mean(s2)- mean(s1); # Observed difference
  aux = c(s1, s2); # all observations
  out = numeric(nreps); # to store differences
  for(i in 1:nreps){
    d = sample(aux, size = n, replace = FALSE); # permuting data
    out[i] = mean(d[(n1+1):n]) - mean(d[1:n1]);
  }
  highprob <- length(out[out >= abs(diffObt)])/nreps;
  lowprob <- length(out[out <= -abs(diffObt)])/nreps;
  prob2tailed <- lowprob + highprob;
  return(list(pvalue = prob2tailed, resampMeanDiff = out,
              diffObt = diffObt, nreps = nreps));
}

set.seed(1)
R = rdm_ind(s1, s2, nreps = 10000)

pdf("drug.pdf")
hist(R$resampMeanDiff, main = "Distribution of Mean Differences",
     xlab = "T*", freq = FALSE, 
     xlim = c(min(R$resampMeanDiff), R$diffObt+0.30));
mtext("Group2 - Group1", 3)
text(R$diffObt, 0.3, "Obs diff");
arrows(R$diffObt, 0.27, R$diffObt, 0, length = .125);
text(R$diffObt, 0.4, paste("p-value = ", R$pvalue, sep =  ""));
dev.off()


x = cbind(drug[drug$treatment == "1", c("score1")], 
          drug[drug$treatment == "1",c("score2")])
colnames(x) = c("score1", "score2")


Ax=drug[drug$treatment == "1", "score1"];
Bx=drug[drug$treatment == "1", "score2"];
Ay=drug[drug$treatment == "2", "score1"];
By=drug[drug$treatment == "2", "score2"];

y = c(Ay,By)
x = c(Ax,Bx)

set.seed(1)
R = rdm_pair(data = x[,c(2,3)], nreps = 10000);
pdf("drug.pdf")
hist(R$resampMeanDiff, main = "Distribution of Mean Differences",
     xlab = "T*", freq = FALSE, 
     xlim = c(min(R$resampMeanDiff), R$diffObt+0.30));
mtext("Group2 - Group1", 3)
text(R$diffObt, 0.3, "Obs diff");
arrows(R$diffObt, 0.27, R$diffObt, 0, length = .125);
text(R$diffObt, 0.4, paste("p-value = ", R$pvalue, sep =  ""));
dev.off()

n = length(y);

f = c(rep("A", length(Ax)), rep("B", length(Bx))); # factor
f = as.factor(f);

fit = lm(y ~ x + f); # linear model
summary(fit);

anova(fit);

d=x$score2-x$score1
B   = 10000;
n = length(d);
out = NULL;

set.seed(1)
for(i in 1:B){
  
  b     = sample(1:n, n, replace = TRUE);
  
  bfit  = lm(y[b] ~ x[b] + f);
  
  out   = c(out, mean(d[b]));
  
}

obs = summary(fit)$coefficients[3,1];
pvalue = (sum(abs(obs) <= out) + sum(-abs(obs)>=out)) / B;
pvalue

pdf("drug_AB.pdf")
par(mar=c(4,4,3,1));
hist(out, xlab = expression(beta[compB]),
     main = "Distribution under Null hypothesis", freq = F);
obs = summary(fit)$coefficients[3,1];
text(obs, 0.6, expression(paste("obs ", beta[compB]),sep=""));
arrows(obs, 0.55, obs, 0, length = .125);
text(obs, .65, paste("p-value= ", pvalue ,sep=""));
dev.off()