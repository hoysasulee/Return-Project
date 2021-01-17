# Portfolio
## Mathematical resources
This project aims at a statistical analysis of hotpot, which is a deliciously spicy Sichuan diet I like. There is nothing that can be exceeded by having a hotpot after the exam to relaxed myself. The hotpot restaurants are everywhere in Sichuan, but I did not have too many experiences about it in Auckland. The figure below illustrates one of the photos that I took in a hotpot restaurant sited on Newmarket. Its flavour made me lose control but wait for the pot boiling is a long process. I noticed several phenomenons that interested me during this tedious process. Why did the spicy soup boil earlier that tomato soup? Why is there some foods can be cooked quickly such as beef tripe while they can also be cooked for a longer time and the flavour stays at good? In contrast, why some foods are too hard to be cooked while are also not able to be cooked too long, such as potatoes? Therefore, I tried to explore the correlation between hotpot foods and the time they should be cooked. I hope it is helpful to provide some advice for you to obtain a tasted flavour when you have an opportunity to enjoy a hotpot next time.
![image](https://github.com/hoysasulee/Return-Project/blob/main/img/img14.png)

The data is given by the traditional Sichuan hotpot cooking schedule combine with some of my suggestions based on health (traditional schedule require to cook beef tripe at most 7 seconds for a crisp taste!).
Time is recorded from when the pot boiled, and the unit of time is minute. When ‘time = 10’ means 10 mintes or more. And the type of foods are splitted into 3 class, which are:
- Meat_type = 1; 
- Vegetable_type = 2; 
-Processed_food_type = 3; 
Import the dataset initially.

```
food <- c("Crispy meat", "Squid","Luncheon meat", "Egg", "Cucumber", "Tomato", "Coriander", "Dried tofu", "Sprouts", "Radish", "Yellow larynx fillet", "Meatball", "Winter melon", "Seaweed", "Basha Fish", "Sliced mutton", "Sliced beef", "Beef tripe", "Chicken kidney", "Shrimp", "Shrimp dumplings", "Crab stick", "Mushroom")

type <- c(3,1,3,1,2,2,2,3,2,2,1,1,2,2,1,1,1,1,1,1,3,3,2)

time_least <- c(0,2,0,1,0,0,1,2,3,3,4,4,4,5,3,3,5,3,6,5,5,5,6)

time_most <- c(10,10,5,8,5,3,1,8,3,5,10,8,8,10,6,8,8,5,10,10,10,8,10)

data <- data.frame(food, type, time_least, time_most)
data
##                    food type time_least time_most
## 1           Crispy meat    3          0        10
## 2                 Squid    1          2        10
## 3         Luncheon meat    3          0         5
## 4                   Egg    1          1         8
## 5              Cucumber    2          0         5
## 6                Tomato    2          0         3
## 7             Coriander    2          1         1
## 8            Dried tofu    3          2         8
## 9               Sprouts    2          3         3
## 10               Radish    2          3         5
## 11 Yellow larynx fillet    1          4        10
## 12             Meatball    1          4         8
## 13         Winter melon    2          4         8
## 14              Seaweed    2          5        10
## 15           Basha Fish    1          3         6
## 16        Sliced mutton    1          3         8
## 17          Sliced beef    1          5         8
## 18           Beef tripe    1          3         5
## 19       Chicken kidney    1          6        10
## 20               Shrimp    1          5        10
## 21     Shrimp dumplings    3          5        10
## 22           Crab stick    3          5         8
## 23             Mushroom    2          6        10

```
## Chi-squared test
In general cognition, we consider that vegetables are more likely to be cooked. However, for instance, the mushroom in hotpot should be cooked for a longer time than meat. Is our cognition really meet the case? Let us explore the time for foods cooking.
```
o <- data$time_least
o
##  [1] 0 2 0 1 0 0 1 2 3 3 4 4 4 5 3 3 5 3 6 5 5 5 6
```
The average length of time by each kind of food can be cooked at least is:
```
mean(o)
## [1] 3.043478
```
We are interested in determining if the data of time_least fits the parameters of a Poisson distribution. we use the Chi-squared to test it. The null in this task is that the least time is satisfied with the Poisson distribution. Firstly, we calculate the expected probabilities of food is cooked for 0 minutes, 1 minute, 2 minutes until we reach 6 minutes which was the maximum observation.
```
probs <- dpois(0:6,lambda = mean(o))
probs[7] <- 1-sum(probs[1:6]) probs
## [1] 0.04766880 0.14507895 0.22077231 0.22397191 0.17041341 0.1037299 0
## [7] 0.08836474
```
Verify if the probabilities can add to 1.
```
sum(probs)
## [1] 1
```
Therefore, the expected least time for 23 foods are:
```
e <- probs*23
e
## [1] 1.096382 3.336816 5.077763 5.151354 3.919508 2.385788 2.032389
```
The chi-square statistic requires to be calculated:
```
B <- sum((table(o)-e)^2/e)
B
## [1] 13.17609
```
The p-value would be (The degrees of Freedom are 7-1-1):
```
pchisq(B,df=7-1-1,lower.tail=FALSE)
## [1] 0.02178331
```
The p-value is less than 0.05, we reject the null and it shows that the least time for hotpot foods cooking does not fit the Poisson distribution.

## Linear regression
Return to our hypothesis: the cooking time depends on the type of foods. A linear model is given to plot the correlation between food types and the least cooking time.Return to our hypothesis: the cooking time depends on the type of foods. A linear model is given to plot the correlation between food types and the least cooking time.
```
plot(data$time_least~type, data = data,xlab="food types", ylab = "least
cooking time") abline(lm(data$time_least~type))
```
The regression line shows that meat is indeed more likely to be cooked for longer time. Is it ture?
```
summary(lm(data$time_least~type))
##
## Call:
## lm(formula = data$time_least ~ type)
##
## Residuals:
## Min 1Q Median 3Q Max
## -2.90625 -1.72188 0.09375 1.46250 3.09375 ##
## Coefficients:
##
## (Intercept)
## type
## ---
## Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1 ##
## Residual standard error: 1.969 on 21 degrees of freedom
## Multiple R-squared: 0.06376, Adjusted R-squared: 0.01917
## F-statistic: 1.43 on 1 and 21 DF, p-value: 0.2451
```
And Fisher test. We set the foods which require more than 3 minutes for the least cooking time as hard-cooked foods.
```
P <- table(meat=data$type<2,hard_cooked=data$time_least>3)
fisher.test(P)
## 
##  Fisher's Exact Test for Count Data
## 
## data:  P
## p-value = 0.685
## alternative hypothesis: true odds ratio is not equal to 1
## 95 percent confidence interval:
##   0.2250208 11.4579311
## sample estimates:
## odds ratio 
##   1.567183
```
The p-value from the results indicate that there is no evidence to support our hypothesis. The possible reason may cause by the unbalance types of the sample we had. The sample included 10 kinds of meat but only 5 types of processed food. In addition, we are interested in discussing the relationship between different foods and the time to keep their texture in hotpot.
```
t <- data$time_most - data$time_least
plot(t~data$type,data=data)
abline(lm(t~data$type))
```
The result shows that processed foods had higher probability to stay at good texture with the time increasing. Verify it.
```
summary(lm(t~data$type))
## 
## Call:
## lm(formula = t ~ data$type)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -4.3594 -1.2328 -0.1062  0.8938  5.3875 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)   
## (Intercept)   3.8531     1.2254   3.144  0.00489 **
## data$type     0.2531     0.6300   0.402  0.69192   
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
## 
## Residual standard error: 2.35 on 21 degrees of freedom
## Multiple R-squared:  0.007628,   Adjusted R-squared:  -0.03963 
## F-statistic: 0.1614 on 1 and 21 DF,  p-value: 0.6919
```
The p-value 0.6919 makes us cannot reject our assumption. Therefore, we consider that processed foods have a higher capability to stay at the boiling pot and keep their texture as well as flavour.

## Conclusion
The dataset of hotpot foods was analysed using statistical methods and a number of results obtained. The results tell us that there is no evidence for meat that is available require to cook longer time. Meanwhile, some meats are not suitable to be cooked for a long time. Therefore, I recommend you to be careful about your meat in the hotpot next time. However, processed foods can be cooked for a long time and keep their flavour and texture. You do not need to worry about them.
