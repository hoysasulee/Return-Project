PROC IMPORT OUT = AKLHourlyElecCon
	DATAFILE = "H:/Data/AKLHourlyElecCon.xlsx"
	DBMS = xlsx REPLACE;
	GETNAMES = YES;
	DATAROW = 2;
RUN;

data AKLHourlyElecCon;
     set AKLHourlyElecCon;
	 format Date2 ddmmyy5.;
     Date2 = input (Datetime, datetime16.);
run;
*proc print data = AKLHourlyElecCon;
*run;

PROC GPLOT DATA = AklHourlyElecCon;
	PLOT MW*Datetime / VAXIS = AXIS1 HAXIS = AXIS2;
    AXIS1 label = (angle = 90 'electricity consumption');
    AXIS2 label = ('DayHour');	
	
RUN; QUIT;

PROC GPLOT DATA = AklHourlyElecCon;
	PLOT Temperature*Datetime / VAXIS = AXIS1 HAXIS = AXIS2;
    AXIS1 label = (angle = 90 'temperature');
    AXIS2 label = ('DayHour');	
	
RUN; QUIT;

PROC GPLOT DATA = AklHourlyElecCon;
	PLOT WindSpeed*Datetime / VAXIS = AXIS1 HAXIS = AXIS2;
    AXIS1 label = (angle = 90 'wind speed');
    AXIS2 label = ('DayHour');	
	
RUN; QUIT;

*proc contents data=AklHourlyElecCon;
*RUN;

proc esm data = AklHourlyElecCon 
		 out = ses_mw
     	 print = forecasts;
   id Datetime interval = hour;
   forecast MW;
run;

title1 "SES for AklHourlyElecCon Data";
proc sgplot data = ses_mw;
   series x = Datetime y = MW / markers
                           markerattrs = (symbol = circlefilled color = red)
                           lineattrs = (color = red);
   refline '01APR16:00:00:00'd / axis=x;
   yaxis minor label = 'megawatts';
   xaxis values = ('01APR16:00:00:00'd to '31MAY16:23:00:00'd by hour) minor label = 'Time';
   RUN; QUIT;

   /* Additive Holt-Winters' Seasonal Exponential Smoothing */
ods graphics on;
ods trace on;
proc esm data = AklHourlyElecCon 
out = hwadd_mw 
outfor = hwadd_fore 
outest = hwaddbetas_mw 
lead = 48 
plot = (forecasts modelforecasts); 
   forecast MW / method = addwinters;
id Datetime interval = hour;
run;

proc print data = hwaddbetas_mw noobs; run;

/*proc print data = hwadd_fore noobs; run;*/

title1 "Additive Holt-Winters' Seasonal Exponential Smoothing for AklHourlyElecCon";
proc sgplot data = hwadd_fore;
   series x = Datetime y = Actual / markers
                           markerattrs = (symbol = circlefilled color = blue)
                           lineattrs = (color = blue);
   series x = Datetime y = Predict / markers
                           markerattrs = (symbol = circlefilled color = red)
                           lineattrs = (color = red);
 
   yaxis minor label = 'megawatts';
   xaxis minor label = 'Datetime';
   RUN; QUIT;

   DATA ferr_add;
   set AklHourlyElecCon;
   set Hwadd_fore;
   err_add = Actual-Predict;
   e2_add = err_add**2;
   pcterr_add = 100*abs(err_add)/abs(MW);
run;  

proc means n mean data = ferr_add;
  title "Out-of-Sample Forecast Accuracy Measures";
  var e2_add pcterr_add;
  label e2_add = "Mean Squared Error, Additive";
  label pcterr_add = "Mean Absolute Percentage Error, Additive";
run;

proc arima data = AklHourlyElecCon;
identify var = MW nlag = 24;
run;
identify var = MW stationarity = (adf = 1); /* Augmented Dickey-Fuller Unit Root Tests */
run;  
identify var = MW stationarity = (pp = 1); /* Phillips-Perron Unit Root Tests */
run;
quit;

*proc arima data = AklHourlyElecCon;
*identify var = MW(1) stationarity = (adf = 1); /* first differencing or change */
*run;
*identify var = MW(1) stationarity = (pp = 1); /* second differencing */
*run; *quit;

title1 "SARIMA(1,0,0)";
proc arima data = AklHourlyElecCon ;
identify var = MW; 
estimate p = 1;  /* ARIMA(1,0,0) */
run; quit;

title1 "SARIMA(1,0,1)";
proc arima data = AklHourlyElecCon;
identify var = MW; 
estimate p = 1 q = 1; /* ARIMA(1,0,1) */
run; quit;

title1 "SARIMA(0,0,1)";
proc arima data = AklHourlyElecCon;
identify var = MW; 
estimate q = 1; /* ARIMA(0,0,1) */
run; quit;

proc arima data = AklHourlyElecCon;
identify var = MW; 
estimate q = 1 method = ML; /* ARIMA(0,0,1) using maximum likelihood (ML)  */
outlier;
forecast lead = 48 interval = HOUR out = results; 
run; quit;

proc arima data = AklHourlyElecCon;
identify var = MW; 
estimate p = 1 method = ML; /* ARIMA(1,0,0) using maximum likelihood (ML)  */
outlier;
forecast lead = 48 interval = HOUR out = results; 
run; quit;

title1 "ARIMAX with Independent Variable";
proc arima data = AklHourlyElecCon;
identify var = MW crosscorr = (Temperature WindSpeed); 
identify var = MW(1) crosscorr = (Temperature(1) WindSpeed(1)); 
run; quit;

title1 "Estimate ARIMAX with Independent Variable iteration 1";
proc arima data = AklHourlyElecCon;
identify var = MW crosscorr = (Temperature WindSpeed); 
estimate p = (4) method = ML input = (Temperature WindSpeed); 
outlier;
run; quit;

title1 "Estimate ARIMAX with Independent Variable iteration 2";
proc arima data = AklHourlyElecCon;
identify var = MW crosscorr = (Temperature WindSpeed);
estimate p = (4) method = ML input = ( (1 4) Temperature WindSpeed); 
outlier;
run; quit;

title1 "Estimate ARIMAX with Independent Variable iteration 3";
proc arima data = AklHourlyElecCon;
identify var = MW(1) crosscorr = (Temperature(1) WindSpeed(1));
estimate p = (4) method = ML input = ( (1 4) Temperature WindSpeed); 
outlier;
run; quit;

title1 "Forecast ARIMAX with Independent Variable";
proc arima data = AklHourlyElecCon;
identify var = Temperature(1); 
estimate p = (4);
identify var = WindSpeed(1); 
estimate p = (4);
identify var = MW(1) crosscorr = (Temperature(1) WindSpeed(1)); 
estimate p = (4) input = ( (1 4) Temperature WindSpeed);
forecast lead = 48 interval = hour out = results; 
run; quit;

/* Out-of-Sample Forecasts */
proc arima data = AklHourlyElecCon;
identify var = MW;
estimate p = (4) method = ML; 
forecast lead = 48 interval = hour id=datetime out = out_results; 
run; quit;

DATA AklHourlyElecCon2;
   SET AklHourlyElecCon;
   if Datetime > "30may2016"d;
run;

DATA out_results2;
   SET out_results;
   if Datetime > "30may2016"d;
   keep Datetime Forecast;
run;

proc print data = out_results2 noobs; run; quit; 

/** Evaluate Forecast Accuracy **/
DATA fore_err;
   set AklHourlyElecCon2;
   set out_results2;
   err_add = MW-Forecast;
   e2_add = err_add**2;
   pcterr_add = 100*abs(err_add)/abs(MW);
run; 

proc means n mean data = fore_err;
title "Out-of-Sample Forecast Accuracy Measures: ARIMAX";
var e2_add pcterr_add;
label e2_add = "Mean Squared Error";
label pcterr_add = "Mean Absolute Percentage Error";
run; quit;
