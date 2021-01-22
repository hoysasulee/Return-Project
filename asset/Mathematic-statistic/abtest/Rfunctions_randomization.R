# More information on 
# https://www.uvm.edu/~statdhtx/StatPages/ResamplingWithR/RandomMatchedSample/RandomMatchedSampleR.html
# https://www.uvm.edu/~statdhtx/StatPages/Randomization%20Tests/RandomMatchedSample/RandomMatchedSample.html

rdm_pair = function(data, nreps){
  
  diffObt <- mean(data[,2]) - mean(data[,1]);
  difference <- data[,2] - data[,1];  
  
  out <- numeric(nreps);
  
  for (i in 1:nreps) {
    signs  <- sample( c(1,-1),length(difference), replace = T);
    resamp <- difference * signs;
    out[i] <- mean(resamp);
  }
  
  highprob  <- length(out[out >=  abs(diffObt)])/nreps;
  lowprob   <- length(out[out <= -abs(diffObt)])/nreps;
  prob2tailed <- lowprob + highprob;
  
  return(list(pvalue = prob2tailed, resampMeanDiff = out,
              diffObt = diffObt, nreps = nreps))
}

rdm_ind = function(g1, g2, nreps){
  
  # g1: data before treatment
  # g2: data after treatment
   
  n1 = length(g1);
  n2 = length(g2);
  n  = n1+n2; # number of observations
  
  diffObt = mean(g2)- mean(g1);
  
  aux = c(g1, g2); # all observations
  
  out = numeric(nreps); # to store differences
  
  for(i in 1:nreps){
    
    d = sample(aux, size = n, replace = FALSE);
    
    out[i] = mean(d[(n1+1):n]) - mean(d[1:n1]);
    
  }
  
  highprob <- length(out[out >=  abs(diffObt)])/nreps;
  lowprob  <- length(out[out <= -abs(diffObt)])/nreps;
  prob2tailed <- lowprob + highprob;
  
  return(list(pvalue = prob2tailed, resampMeanDiff = out,
              diffObt = diffObt, nreps = nreps));
  
}
