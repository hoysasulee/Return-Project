### Part 1

The January and February 2014 S&P 500 options data are provided in the file ‘option(Jan2014-Feb2014).csv’ available in Blackborad. Following the VIX formula provided in the VIX white paper [1], choose appropriate options data from the spreadsheet provided to find the VIX value of S&P 500 on a particular day. Show details of your working including a description how you implement the formula in SAS.
Note that columns are "date", "tau", "K", "call_option_price", "S", "r", "put_option_price" in the data. 
- "date" is the date of the options.
- "tau" is the time to option maturity, measured in calendar days.
- "K" is the option strike price.
- "call_option_price" is the call option price. 
- "S" is the S&P 500 index value on the day. 
- "r" is the annual risk free interest rate. 
- "put_option_price" is the put option price.
Note that the data is given in calendar days, so you need to divide by 365 when you convert the time from days to years.
This task can be divided into a sequence of sub-tasks:
1. Find the mid-quote price △Ki as defined in [CBOE Volatility index(VIX)white papers studies](http://www.cboe.com/aboutcboe/mediahub/cboe-volatility-index-(vix)-white-papers-studies)
2. Find the contributions by strike.
3. Calculate volatility for both near-term and next-term options.
4. Calculate the 30-day weighted average variance for near-term and next-term options. Then take the square root of that value and multiply by 100 to get VIX.

### Part 2:
Using the option values on the day you choose to calculate at-the-money implied volatility. 
At-the- money is a term used to describe an option contract with a strike price that is closest to the underlying market price. 
Apply the Newton-Raphson method to find an estimate of the at-the-money implied volatility. 
Show details of your working including a description how you find the at-the-money implied volatility in SAS.

### Part 3:
By repeating the methods in Parts 1 and 2, calculate several more values of VIX and at-the-money implied volatility. Then, write a short essay (within 1000 words) to explain the differences and similarities between the values of VIX and at-the-money implied volatility. You need to provide the additional values of VIX and at-the-money implied volatility you obtained (which are not shown in Parts 1 and 2), but don’t need to include the details of your calculation and implementation on these values.
