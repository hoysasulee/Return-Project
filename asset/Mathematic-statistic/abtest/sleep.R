source("Rfunctions_randomization.R")
library("PairedData")
data("sleep")
 
x = cbind(sleep[sleep$group == "1", c("ID", "extra")], 
          sleep[sleep$group == "2",c("extra")])
          
colnames(x) = c("ID", "g1", "g2")

### Randomization test ###
set.seed(1)
R = rdm_pair(data = x[,c(2,3)], nreps = 10000);

pdf("sleep.pdf")
hist(R$resampMeanDiff, main = "Distribution of Mean Differences",
     xlab = "T*", freq = FALSE, 
     xlim = c(min(R$resampMeanDiff), R$diffObt+0.30));
mtext("Group2 - Group1", 3)
text(R$diffObt, 0.3, "Obs diff");
arrows(R$diffObt, 0.27, R$diffObt, 0, length = .125);
text(R$diffObt, 0.4, paste("p-value = ", R$pvalue, sep =  ""));
dev.off()

# pvalue
obs = R$diffObt;
out = R$resampMeanDiff;
pvalue = (sum(abs(obs) <= out) + sum(-abs(obs)>=out)) / 10000;
pvalue

### bootstrap CI ###

d = x$g2 - x$g1; # mean difference
n = length(d); # number observations

B   = 10000; # number of bootstrap samples
out = NULL; # to store results

set.seed(1)
for(i in 1:B){
  
  b     = sample(1:n, n, replace = TRUE);
  out   = c(out, mean(d[b]));
  
}

round(quantile(out, probs = c(0.025, 0.975)),2); # bootstrap CI

hist(out, main = "Bootstrap distribution of Mean Differences",
     xlab = "T*", freq = FALSE);
