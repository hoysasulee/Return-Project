Question 1 - Matlab basics (25pt)
Plot the following functions


Make the range of  from -2 to 2.
% Insert your code here
x = linspace(-2,2) % variable for the functions
f=  exp(-x.^(2)/4).*cos(2*pi.*x)  ;
%Plotting first function f(x)
plot(x,f);
xlabel( 'x' );
ylabel( 'y'  );

Complete the following script for the second function
% Second function g(x)
x=linspace(-2,0); % Range of x from -2 to 0 
%g(x) for x<=0
g1= exp(x) ; 
%Plotting g(x) for x<=0
plot(x,g1) 
hold on
x=linspace(0,2); %Range of x from 0 to 2
%g(x) for x>0
g2= sin(2*pi.*x)./x ;
%Plotting g(x) for x>0
plot(x,g2)
xlabel('x');
ylabel('g(x)');
legend('g1(x)','g2(x)'   );
hold off

Question 2 - Analyzing Census Data (25pt)
1. Visualize the Population Change Over Time

Plot the US population data against the year.
years = (1900:10:2000);                                  % Time interval
pop = [75.995 91.972 105.711 123.203 131.669 ...         % Population Data
   150.697 179.323 213.212 228.505 250.633 265.422]

Plot the data by completing the script below.
plot(years, pop)                           % Plot the population data
title('US population data ');
ylabel('Population');
xlabel('Years')

2. Fitting the Data

Can we predict the US population in the year 2010? Let's try fitting the data with polynomials. We'll use the MATLAB polyfit function to get the coefficients. 
The fit equations are:

Complete th following script.
x = (years-1900)/50;
coef1 = polyfit(x,pop,1)  % linear
coef2 = polyfit(x,pop,1) % Quad
coef3 = polyfit(x,pop,3)  % Cubic

3. Plotting the Curves
Create sections with any number of text and code lines.
We can plot the linear, quadratic, and cubic curves fitted to the data. We'll use the polyval function to evaluate the fitted polynomials at the points in x. Complete the following script
pred1 = polyval(coef1,x);
pred2 = polyval(coef2,x);
pred3 = polyval(coef3,x);
[pred1; pred2; pred3]
Now let's plot the predicted values for each polynomial.
hold on
plot(years,pred1)
plot(years,pred2)
plot(years,pred3)
ylim([50 300])
legend('Data', 'Linear', 'Quadratic' ,'Cubic')
hold off


Question 3 - Sinusoidal waves (25pt)
1. Integral of waves (10pt)
A relationship between an input and an output is given by

where  and  are the input and the output, respectively. Compute  for  ranging from 0 to 0.2 with 0.001 interval (201 samples), when the input is given by:

Set the parameters to  and .  Plot the resulting output function by completing the following script.
% Write your codes here
t = 0:0.001:0.2; % Set the output time array
R = 0.01; C = 4;
U = @(t) sin(100*pi*t);
X = zeros(1,length(t));
for k=1:length(t)
    if t(k)<0
        U=0;
    elseif t(k) >= 0
        U=sin(100*pi*t(k));
    end
F = @(s) exp(-s/(R*C))*U  ;
X(k) = integral(F,0,t(k)); % Find how to use this in help
end

figure
plot(t,X/(R*C))
xlabel('t')
ylabel('X(t)')
Note: Beware that the input function becomes zero when its variable is negative. So, you have to be careful with the integral range. 

2. Use the fft to find the frequencies of the combined waves (15pt)
First, generate the combined sinusoidal wave as done below.
% Generate example time series
t = 0:1/1000:0.2-1/1000; 
% Sampled at 1 ms for .2 sec. Make the sample nuber even. 
% This works better for FFT

% 3 freqeuncies
w1 = 2*pi*60;
w2 = 2*pi*71;
w3 = 2*pi*89;

% 3 amplitudes
A1 = 1;
A2 = 1/2;
A3 = 1/3;

% generate the three sinusoides
f1 = A1*sin(w1*t);
f2 = A2*sin(w2*t);
f3 = A3*sin(w3*t);
Then, add noise to the amplitude of each sinusoid and shift its phase randomly. I will leave the variance of the noise to your decision. Plot the resulting sum of the three waves.
f = f1+f2+f3;
plot(t,f) % f is the combined wave 
Use fft to find the three frequencies.
F = fft(f);
W = (0:length(F)-1)*1000/length(F); 
% Complet the rest
n = length(t);                         
fshift = (-n/2:n/2-1)*(1000/n)  ;
yshift = fftshift(F)   ; %Shifts zero-frequency components to the center 
plot(fshift,abs(yshift)/n*2)
% Normalising fft to get the correct values of the amplitudes.
xlabel('Hz')


Question 4 - Moving average analysis of stock index (25pt)
Use the centred moving average to analyze the stock market data. 

Analyze the stock market data from FTSE100. Download ftse100.mat, which is in `table' format, so you need to find a way to use a table data in Matlab. Write you analysis of this particular stock market movement in 100 ~ 150 words.
load ftse100.mat
date = (ftse100.Feb2018)
price = (ftse100.VarName2)
plot(date,price)
Hint: you may find the following useful.
windowsize = 3;
M = movmean(price,windowsize);
plot(date,price,date,M);
windowsize = 5;
M = movmean(price,windowsize);
plot(date,price,date,M);
windowsize = 10;
M = movmean(price,windowsize);
plot(date,price,date,M);
windowsize = 20;
M = movmean(price,windowsize);
plot(date,price,date,M);
windowsize = 30;
M = movmean(price,windowsize);
plot(date,price,date,M);
windowsize = 60;
M = movmean(price,windowsize);
plot(date,price,date,M);
The FTSE100 stock market data is analyzed by moving average method in this case, in order to obtain the general trend of stock price. Through this method, it will return an array of local k-point average values, where each mean is calculated over a sliding window of length k across neighboring elements of A, which is set as stock price in this case. 
According to the output plots of this analysis, the model with 20 windowsize fit the actual data better compare with others. It filtered the excess outers and noises in the original data and illustrates that the stock price dropped from August 2017 to October 2017 but increased till about November 2017. Then the stock price started fluctuation and climbed to the peak at the mid of Jan 2018. After this period, the stock dropped to the lowest price in Feb 2018.
