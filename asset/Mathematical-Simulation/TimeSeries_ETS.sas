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
	symbol1 i = join v = star c = blue;
RUN; QUIT;

proc esm data = NZecard out = ses_ecard print = forecasts;;
   id Date2 interval = quarter;
   forecast Consumables;
run;

title1 "SES for NZ E-card Data";
proc sgplot data = ses_ecard;
   series x = Date2 y = Consumables / markers
                           markerattrs = (symbol = circlefilled color = red)
                           lineattrs = (color = red);
   refline '01Oct2019'd / axis=x;
   yaxis minor label = 'NZD Millions';
   xaxis values = ('01oct02'd to '01oct22'd by year2) minor label = 'Time';
   RUN; QUIT;

proc esm data = NZecard outfor = ecard_fore outest = betas lead = 4;
   id Date2 interval = quarter;
   forecast Consumables;
run;

proc print data=betas noobs;
run;

/* SES with linear trend */
proc esm data = NZecard out = sestr_ecard outfor = ecardtr_fore outest = betastr lead = 12;
   id Date2 interval = quarter;
   forecast Consumables / method = linear;
run;

proc print data=betastr noobs;
run;

title1 "SES (with Linear Trend) for NZ E-card Data";
proc sgplot data = sestr_ecard;
   series x = Date2 y = Consumables / markers
                           markerattrs = (symbol = circlefilled color = red)
                           lineattrs = (color = red);
   refline '01Oct2019'd / axis=x;
   yaxis minor label = 'NZD Millions';
   xaxis values = ('01oct02'd to '01oct22'd by year2) minor label = 'Time';
   RUN; QUIT;

/* SES with damped trend */

/* Read the data */
PROC IMPORT OUT = NZTourists
	DATAFILE = "H:/Nate-Nate/Nate/Teaching/AUT/MATH803-Y2020-S1/Lab/NZTourists.xlsx"
	DBMS = xlsx REPLACE;
	GETNAMES = YES;
	DATAROW = 2;
RUN;

data NZtourists;
     set NZTourists;
     Date = mdy( MONTH(DateTime), 1, YEAR(DateTime) );
     format Date mmyys7.;
run;

/* Plot the data */
PROC GPLOT DATA = NZtourists;
	PLOT Actual*Date / VAXIS = AXIS1 HAXIS = AXIS2;
    AXIS1 label = (angle = 90 'No. of Tourists');
    AXIS2 label = ('Month')
          order = ('01dec09'd to '01dec19'd by year);
    symbol i = join v = star c = green;	
RUN; QUIT;

proc esm data = NZtourists out = sestr_tour outfor = tourtr_fore outest = betas_tourtr lead = 12;
   id Date interval = month;
   forecast Actual / method = linear;
run;

proc print data=betas_tourtr noobs;
run;

title1 "SES (with Linear Trend) for NZ Tourists Data";
proc sgplot data = sestr_tour;
   series x = Date y = Actual / markers
                           markerattrs = (symbol = circlefilled color = red)
                           lineattrs = (color = red);
   refline '01dec19'd / axis=x;
   yaxis minor label = 'NZD Millions';
   xaxis values = ('01dec09'd to '01dec20'd by year) minor label = 'Month';
   RUN; QUIT;

/* proc esm with plot = all */
proc esm data = NZtourists out = sesdtr_tour outfor = tourdtr_fore outest = betas_tourdtr lead = 12 plot = all;
   id Date interval = month;
   forecast Actual / method = damptrend;
run;

proc print data=betas_tourdtr noobs;
run;

title1 "SES (with Damped Trend) for NZ Tourists Data";
proc sgplot data = sesdtr_tour;
   series x = Date y = Actual / markers
                           markerattrs = (symbol = circlefilled color = red)
                           lineattrs = (color = red);
   refline '01dec19'd / axis=x;
   yaxis minor label = 'NZD Millions';
   xaxis values = ('01dec09'd to '01dec20'd by year) minor label = 'Month';
   RUN; QUIT;

/* Seasonal Exponential Smoothing */
proc esm data = NZtourists out = sses_tour outfor = stour_fore 
outest = sbetas_tour lead = 12 plot = (forecasts modelforecasts);
   forecast Actual / method = seasonal;
   id Date interval = month; 
run;

proc print data = sbetas_tour noobs; run;

title1 "Seasonal Exponential Smoothing for NZ Tourists Data";
proc sgplot data = sses_tour;
   series x = Date y = Actual / markers
                           markerattrs = (symbol = circlefilled color = red)
                           lineattrs = (color = red);
   refline '01dec19'd / axis=x;
   yaxis minor label = 'NZD Millions';
   xaxis values = ('01dec09'd to '01dec20'd by year) minor label = 'Month';
   RUN; QUIT;

/* Holt-Winters' Seasonal Exponential Smoothing */
proc esm data = NZtourists out = hwses_tour outfor = hwtour_fore 
outest = hwsbetas_tour lead = 12 plot = (forecasts modelforecasts);
   forecast Actual / method = winters;
**or use forecast Actual/method = addwinters; /*for additive model */
   id Date interval = month; 
run;

proc print data = hwsbetas_tour noobs; run;

title1 "Holt-Winters' Seasonal Exponential Smoothing for NZ Tourists Data";
proc sgplot data = hwses_tour;
   series x = Date y = Actual / markers
                           markerattrs = (symbol = circlefilled color = red)
                           lineattrs = (color = red);
   refline '01dec19'd / axis=x;
   yaxis minor label = 'NZD Millions';
   xaxis values = ('01dec09'd to '01dec20'd by year) minor label = 'Month';
   RUN; QUIT;

/* Out-of-Sample Forecasts */

/** Additive HW Seasonal Exponential Smoothing for Tranining Set **/
proc esm data = NZtourists out = hwses_tour outfor = hwtour_fore 
outest = hwsbetas_tour lead = 24 plot = (forecasts modelforecasts); /* forecast 24 periods */
where Date < "01jan18"d; /* hold out data for 24 periods */
   forecast Actual / method = addwinters;
id Date interval = month;
run;

/** Multi-step Ahead Forecasts **/
/*
proc esm data = NZtourists out = hwses_tour outfor = hwtour_fore 
outest = hwsbetas_tour lead = 12 back = 24 plot = (all); ** 'back = 24' is multi-step ahead forecasts 
   forecast Actual / method = addwinters;
id date interval = month;
run;
*/

/** Create Test Set **/
DATA NZtourists2;
   SET NZtourists;
   if Date > "01dec2017"d;
run;

DATA Hwtour_fore2;
   SET Hwtour_fore;
   if Date > "01dec2017"d;
   keep Date Predict;
run;

/** Evaluate Forecast Accuracy **/
DATA fore_err;
   set NZtourists2;
   set Hwtour_fore2;
   err_add = Actual-Predict;
   e2_add = err_add**2;
   pcterr_add = 100*abs(err_add)/abs(Actual);
run; 

proc means n mean data = fore_err;
title "Out-of-Sample Forecast Accuracy Measures: HW Additive";
var e2_add pcterr_add;
label e2_add = "Mean Squared Error, Additive";
label pcterr_add = "Mean Absolute Percentage Error, Additive";
run;
