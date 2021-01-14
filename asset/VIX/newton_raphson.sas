PROC IMPORT OUT= WORK.SPX_row
DATAFILE= "H:\Data\option(Jan2014-Feb2014).csv"
REPLACE;
RUN;

/* near-term put */
proc iml;
start main;
T=0.0438;
r=0.0018;
sigma=0.2;
K=1830;
S0=1831.98;
pi = constant("pi");
total_run=10;
do i = 1 to total_run;
d1=(log(S0/K)+(r+sigma**2/2)*T)/(sigma*sqrt(T));
d2=d1-sigma*sqrt(T);
f=S0*cdf("Normal",d1)-K*(exp(-r*T)*cdf("Normal",d2));
vega=S0*1/sqrt(2*pi)*exp(-d1**2/2)*sqrt(T);
g=f-16.05;
sigma=sigma-g/vega;
print sigma d1 f g vega;
end;
finish main;
run;

/* near-term call */
proc iml;
start main;
T=0.0438;
r=0.0018;
sigma=0.2;
K=1835;
S0=1831.98;
pi = constant("pi");
total_run=10;
do i = 1 to total_run;
d1=(log(S0/K)+(r+sigma**2/2)*T)/(sigma*sqrt(T));
d2=d1-sigma*sqrt(T);
f=S0*cdf("Normal",d1)-K*(exp(-r*T)*cdf("Normal",d2));
vega=S0*1/sqrt(2*pi)*exp(-d1**2/2)*sqrt(T);
g=f-15;
sigma=sigma-g/vega;
print sigma d1 f g vega;
end;
finish main;
run;

/* next-term put */
proc iml;
start main;
T=0.0986;
r=0.0022;
sigma=0.2;
K=1825;
S0=1831.98;
pi = constant("pi");
total_run=10;
do i = 1 to total_run;
d1=(log(S0/K)+(r+sigma**2/2)*T)/(sigma*sqrt(T));
d2=d1-sigma*sqrt(T);
f=S0*cdf("Normal",d1)-K*(exp(-r*T)*cdf("Normal",d2));
vega=S0*1/sqrt(2*pi)*exp(-d1**2/2)*sqrt(T);
g=f-25.45;
sigma=sigma-g/vega;
print sigma d1 f g vega;
end;
finish main;
run;

/* next-term call */
proc iml;
start main;
T=0.0986;
r=0.0022;
sigma=0.2;
K=1835;
S0=1831.98;
pi = constant("pi");
total_run=10;
do i = 1 to total_run;
d1=(log(S0/K)+(r+sigma**2/2)*T)/(sigma*sqrt(T));
d2=d1-sigma*sqrt(T);
f=S0*cdf("Normal",d1)-K*(exp(-r*T)*cdf("Normal",d2));
vega=S0*1/sqrt(2*pi)*exp(-d1**2/2)*sqrt(T);
g=f-25.05;
sigma=sigma-g/vega;
print sigma d1 f g vega;
end;
finish main;
run;
