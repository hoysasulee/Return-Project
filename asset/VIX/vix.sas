PROC IMPORT OUT= WORK.SPX_row
DATAFILE= "H:\Data\option(Jan2014-Feb2014).csv"
REPLACE;
RUN;

data spx;
 set SPX_row;
 T = tau/365;
run;

*proc print data = spx;
*run;

proc iml;
use spx var{date T k call_option_price r s put_option_price} where(date = '2014-01-02');
read all var {date} into date;
read all var {T} into T;
read all var {k} into k;
read all var {r} into r;
read all var {s} into s;
read all var {call_option_price} into c;
read all var {put_option_price} into p;
F = K + exp(r#T) # (c - p);
K0 = int(F);
deltak = 5;
lab = choose(k<k0,'put','mix');
lab = choose(k>k0,'call',lab);
Q = choose(k<k0,p,(p+c)/2);
Q = choose(k>k0,c,Q);
right = 1/T#(F/k0-1)##2;
con = (deltak/k##2)#exp(r#T)#Q;
w_con = 2/T#con;
n=nrow(k);
sum=j(n,1,.);
do i = 1 to n=nrow(k);
sum[30] = sum((deltak/k[30]##2)#exp(r[30]#T[30])#Q[30]);
end;
vol = w_con - right;
w_con1 = 0.000164842;
w_con2 = 0.006325309;
right1 = right[1,];
right2 = right[31,];
T1 = T[1,];
T2 = T[31,];
vol1 = w_con1-right1;
vol2 = w_con2-right2;
NT1 = 16*1440;
NT2 = 36*1440;
N30 = 43200;
N365 = 525600;
VIX = 100*sqrt((T1*vol1*((NT2-N30)/(NT2-NT1))+T2*vol2*((N30-NT1)/(NT2-NT1)))*N365/N30);
*create x var {date F T k k0 c r p}; /** create data set **/
*append;       /** write data in vectors **/
*close x;
print k0 k lab p c Q con w_con vol1 vol2 VIX;
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

