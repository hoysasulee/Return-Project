*****************;
* NZ Population *;
*****************;

TITLE 'Annual New Zealand Population in 1840-2011 (Thousands)';

/* Read in the data (Data-step) */
PROC IMPORT OUT = NZPop
	DATAFILE = "H:/Nate-Nate/Nate/Teaching/AUT/MATH803-Y2020-S1/Lab/NZPop.xlsx"
	DBMS = xlsx REPLACE;
	GETNAMES = YES;
	DATAROW = 2;
	*RANGE = "matrix$A2:B132";
RUN;

/* Convert character dates to SAS datetime variable */ 
Data NZPop;
set NZPop;
Time2 = input ( Time, 4. );
Time3 = mdy(1, 1, Time2);
format Time3 year4.;
Run;

proc print data = NZPop noobs;
run;

PROC GPLOT DATA = NZPop;
	PLOT Population*Time2 / VAXIS = AXIS1 HAXIS = AXIS2;
    AXIS1 label = (angle = 90 'Thousands');
    AXIS2 label = ('Year')
          order = ( 1840 to 2011 by 10); 
	symbol1 i = join v = star c = blue;
RUN; QUIT;

/*********************/
/* Non-sesonal ARIMA */
/*********************/

/* Identification Stage */
proc arima data = NZPop ;
*identify var = Population nlag = 24;
*run;
identify var = Population stationarity = (adf = 1); /* Augmented Dickey-Fuller Unit Root Tests */
run; 
*identify var = Population stationarity = (pp = 1); /* Phillips-Perron Unit Root Tests */
*run;
quit;

proc arima data = NZPop ;
identify var = Population(1) stationarity = (adf = 1); /* first differencing or change */
run;
identify var = Population(2) stationarity = (adf = 0); /* second differencing */
run; quit;

/* Estimation and Diagnostic Check Stage */
proc arima data = NZPop ;
identify var = Population(1); 
estimate p = 1;  /* ARIMA(1,1,0) */
run; quit;

proc arima data = NZPop ;
identify var = Population(1); 
estimate p = 1 q = 1; /* ARIMA(1,1,1) */
run; quit;

proc arima data = NZPop ;
identify var = Population(1); 
estimate q = 1; /* ARIMA(0,1,1) */
run; quit;

/* Forecasting Stage */
proc arima data = NZPop ;
identify var = Population(1); 
estimate p = 1 method = ML; /* ARIMA(1,1,0) using maximum likelihood (ML)  */
outlier;
forecast lead = 5 interval = year id = Time3 out = results; 
run; quit;

/*****************/
/* Sesonal ARIMA */
/*****************/

************************************;
* NZ Consumable e-Card Transaction *;
************************************;

TITLE1 'Quarterly New Zealand Consumable e-Card Transaction';
TITLE2 'Quarter 4, 2002 – Quarter 4, 2019';

/* Read in the data (Data-step) */
PROC IMPORT OUT = NZeCard
	DATAFILE = "H:/Nate-Nate/Nate/Teaching/AUT/MATH803-Y2020-S1/Lab/NZeCard.xlsx"
	DBMS = xlsx REPLACE;
	GETNAMES = YES;
	DATAROW = 2;
	*RANGE = "matrix$A2:B132";
RUN;

/* Convert character dates to numerics */ 
data NZeCard;
set NZeCard;
format Date2 yyq4.;
Date2 = input ( Date, yyq6.);
run;

proc print;
run;

PROC GPLOT DATA = NZeCard;
	PLOT Consumables*Date2 / VAXIS = AXIS1 HAXIS = AXIS2;
    AXIS1 label = (angle = 90 'NZD Millions');
    AXIS2 label = ('Time')
          order = ('01oct02'd to '01oct20'd by year2); 
RUN; QUIT;

/* Identification Stage */
proc arima data = NZeCard;
identify var = Consumables stationarity = (adf = 1); /* Augmented Dickey-Fuller Unit Root Tests */
run; quit;

proc arima data = NZeCard;
identify var = Consumables(1) stationarity = (adf = 1); /* Augmented Dickey-Fuller Unit Root Tests */
run; quit;

/* Estimation and Diagnostic Check Stage */
proc arima data = NZeCard;
identify var = Consumables(1); 
estimate p = (4) method = ML;  /* ARIMA(0,1,0)(1,0,0)4 */
outlier;
run; quit;

proc arima data = NZeCard;
identify var = Consumables(1); 
estimate p = (1 4) method = ML;  /* ARIMA(1,1,0)(1,0,0)4 */
outlier;
run; quit;

/* Forecasting Stage */
proc arima data = NZeCard;
identify var = Consumables(1); 
estimate p = (4) method = ML;  /* ARIMA(0,1,0)(1,0,0)4 */
outlier;
forecast lead = 8 interval = quarter id = Date2 out = results; 
run; quit;

/* Out-of-Sample Forecasts */
proc arima data = NZeCard;
identify var = Consumables(1); 
estimate p = (4) method = ML;  /* ARIMA(0,1,0)(1,0,0)4 */
where Date2 < "01jan18"d; /* hold out data for 8 periods */
forecast lead = 8 interval = quarter id = Date2 out = out_results; 
run; quit;

/** Create Test Set **/
DATA NZeCard2;
   SET NZeCard;
   if Date2 > "01dec2017"d;
run;

DATA out_results2;
   SET out_results;
   if Date2 > "01dec2017"d;
   keep Date2 Forecast;
run;

/* proc print data = out_results2 noobs; run; quit; */

/** Evaluate Forecast Accuracy **/
DATA fore_err;
   set NZeCard2;
   set out_results2;
   err_add = Consumables-Forecast;
   e2_add = err_add**2;
   pcterr_add = 100*abs(err_add)/abs(Consumables);
run; 

proc means n mean data = fore_err;
title "Out-of-Sample Forecast Accuracy Measures: ARIMA(0,1,0)(1,0,0)4";
var e2_add pcterr_add;
label e2_add = "Mean Squared Error";
label pcterr_add = "Mean Absolute Percentage Error";
run; quit;

/*********************************************************/
/* ARIMA with Independent Variable or Regressor (ARIMAX) */
/*********************************************************/

********************************;
*********** NZ GDP *************;
********************************;

/* Read in the data (Data-step) */
PROC IMPORT OUT = NZGDP
	DATAFILE = "H:/Nate-Nate/Nate/Teaching/AUT/MATH803-Y2020-S1/Lab/NZGDP.xlsx"
	DBMS = xlsx REPLACE;
	GETNAMES = YES;
	DATAROW = 2;
RUN;

/* Convert character dates to numerics */ 
data NZGDP;
set NZGDP;
format Date2 yyq4.;
Date2 = input ( Date, yyq6.);
run;

/* Subset the data */
DATA NZGDP2;
   SET NZGDP;
   IF '01oct02'd <= Date2 <= '01oct20'd;
   RUN;

/* Combine two datasets */
data GDP_eCard;
   set NZGDP2;
   set NZeCard;
run; 

proc print data = GDP_eCard;
   var Date Date2 GDP Consumables;
run;

/* Identification Stage */
proc arima data = GDP_eCard;
identify var = Consumables crosscorr = GDP; 
identify var = Consumables(1) crosscorr = GDP(1); 
run; quit;

/* Estimation and Diagnostic Check Stage */
proc arima data = GDP_eCard;
identify var = Consumables(1) crosscorr = GDP(1); 
estimate p = (4) method = ML input = GDP; /* With GDP Growth */
outlier;
run; quit;

proc arima data = GDP_eCard;
identify var = Consumables(1) crosscorr = GDP(1); 
estimate p = (4) method = ML input = ( (1 4) GDP); /* With current GDP and 1 and 4 lags of GDP Growth */
outlier;
run; quit;

/* Forecasting Stage */
proc arima data = GDP_eCard;
identify var = GDP(1); 
estimate p = (4);
identify var = Consumables(1) crosscorr = GDP(1); 
estimate p = (4) input = ( (1 4) GDP);
forecast lead = 8 interval = quarter id = Date2 out = results; 
run; quit;


