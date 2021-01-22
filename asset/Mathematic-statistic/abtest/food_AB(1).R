Ax = c(255,234,232,254,264,271,288,290,291,311,300,326,299,296,303);
Ay = c(10,11.9,12.1,12.3,12.4,12.8,12.8,13.4,13.6,14,14.6,14.8,14.8,15.1,16.5);

Bx = c(259,264,278,279,300,296,309,320,311,294,398,334,337,213,329);
By = c(12.6,13,13.5,13.6,13.9,13.9,14.4,15.2,15.3,15.5,15.6,15.6,15.8,17.1,17.8);

# data read from slides
data = scan(text = "255 10.0 259 12.6
            234 11.9 264 13.0
            232 12.1 278 13.5
            254 12.3 279 13.6
            264 12.4 300 13.9
            271 12.8 296 13.9
            288 12.8 309 14.4
            290 13.4 320 15.2
            291 13.6 311 15.3
            311 14.0 294 15.5
            300 14.6 398 15.6
            326 14.8 334 15.6
            299 14.8 337 15.8
            296 15.1 213 17.1
            303 16.5 329 17.8");

data = matrix(data, ncol = 4, byrow = TRUE);

Ax = data[,1]; # body weight for compound A
Ay = data[,2]; # liver weight for compound A

Bx = data[,3]; # body weight for compound B
By = data[,4]; # liver weight for compound B

plot(Ax, Ay, col="red");
points(Bx, By, col = "blue");

y = c(Ay,By); # all responses
x = c(Ax,Bx); # all independent variables

n = length(y);

f = c(rep("A", length(Ax)), rep("B", length(Bx))); # factor
f = as.factor(f);

fit = lm(y ~ x + f); # linear model
summary(fit);

anova(fit);

# we can change the baseline as follows: f = relevel(f, "B");

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
hist(out, xlab = expression(beta[compB]),
     main = "Distribution under Null hypothesis", freq = F);
obs = summary(fit)$coefficients[3,1];
text(obs, 0.6, expression(paste("obs ", beta[compB]),sep=""));
arrows(obs, 0.55, obs, 0, length = .125);
text(obs, .65, paste("p-value= ", pvalue ,sep=""));
dev.off()


### Bootstrap ####
# CI for the difference

# Bootstrap as test is not as accurate as doing a permutation test
# pg 63 BOOTSTRAP METHODS AND PERMUTATION TESTS
# by Tim Hesterberg/Shaun Monaghan/David S. Moore/Ashley Clipson/Rachel Epstein

B   = 10000;
out = NULL;

for(i in 1:B){
  
  b     = sample(1:n, n, replace = TRUE);
  
  f1    = relevel(f[b], "A"); # A as baseline
  bfit  = lm(y[b] ~ x[b] + f1);
  
  out   = c(out, summary(bfit)$coefficients[3,1]);
  
}

# This CI contains 0, which is in agreement with randomization test
round(quantile(out, prob = c(0.025, 0.975)), 3); # bootstrap CI
hist(out, xlab = "Difference in average");

obs = summary(fit)$coefficients[3,1];
abline(v = obs, lty = 2); # observed statistic
