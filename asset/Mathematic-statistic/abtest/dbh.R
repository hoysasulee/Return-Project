# From Handbook of small data sets
# https://www2.stat.duke.edu/courses/Fall09/sta114/data/hand.html
# file name = dopamine.dat

source("Rfunctions_randomization.R")

psychotic = c(.0104,	.0105,	.0112,	.0116,	.0130,	.0145,	.0154,
               .0156,	.0170,	.0180,	.0200,  .0200,	.0210,	.0230,	
              .02520)
              
nonpsychotic = c(.0150,	.0204,	.0208,	.0222,	.0226,	.0245,	.0270,
                 .0275,	.0306,	.0320)	

set.seed(1)
R = rdm_ind(g1 = psychotic, g2 = nonpsychotic, nreps = 10000)


pdf("dbh.pdf")
par(mar=c(4,4,3,1))
hist(R$resampMeanDiff, xlab = "Mean difference", freq = F,
     main = "Distribution under Null hypothesis")
mtext("nonpsychotic - psychotic", 3)
text(R$diffObt, 80, expression(paste("obs diff",sep="")))
arrows(R$diffObt, 75, R$diffObt, 0, length = .125);
text(R$diffObt, 90, paste("p-value= ", R$pvalue ,sep=""))
dev.off()

### Bootstrap for the difference ###

n_psc  = length(psychotic);   # number of observations in psychotic group
n_npsc = length(nonpsychotic); # number of observations in nonpsychotic group

N = 1000; # number ofbootstrap samples
out = NULL; # number of bootstrap samples

for(i in 1:N){
  
  b_psc  = sample(1:n_psc, n_psc, replace = TRUE);
  b_npsc = sample(1:n_npsc, n_npsc, replace = TRUE);
  
  out = c(out, mean(nonpsychotic[b_npsc]) - mean(psychotic[b_psc]));
  
}

hist(out);

round(quantile(out, probs = c(0.025,0.975)), 4);# bootstrap confidence interval

