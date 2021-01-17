# Portfolio
## Mathematical resources
This project aims at a statistical analysis of hotpot, which is a deliciously spicy Sichuan diet I like. There is nothing that can be exceeded by having a hotpot after the exam to relaxed myself. The hotpot restaurants are everywhere in Sichuan, but I did not have too many experiences about it in Auckland. The figure below illustrates one of the photos that I took in a hotpot restaurant sited on Newmarket. Its flavour made me lose control but wait for the pot boiling is a long process. I noticed several phenomenons that interested me during this tedious process. Why did the spicy soup boil earlier that tomato soup? Why is there some foods can be cooked quickly such as beef tripe while they can also be cooked for a longer time and the flavour stays at good? In contrast, why some foods are too hard to be cooked while are also not able to be cooked too long, such as potatoes? Therefore, I tried to explore the correlation between hotpot foods and the time they should be cooked. I hope it is helpful to provide some advice for you to obtain a tasted flavour when you have an opportunity to enjoy a hotpot next time.
[image!](https://github.com/hoysasulee/Return-Project/blob/main/img/img14.png)

The data is given by the traditional Sichuan hotpot cooking schedule combine with some of my suggestions based on health (traditional schedule require to cook beef tripe at most 7 seconds for a crisp taste!).
Time is recorded from when the pot boiled, and the unit of time is minute. When ‘time = 10’ means 10 mintes or more. And the type of foods are splitted into 3 class, which are:
- Meat_type = 1; 
- Vegetable_type = 2; 
-Processed_food_type = 3; 
Import the dataset initially.

```
food <- c("Crispy meat", "Squid","Luncheon meat", "Egg", "Cucumber", "T
omato", "Coriander", "Dried tofu", "Sprouts", "Radish", "Yellow larynx fillet", "Meatball", "Winter melon", "Seaweed", "Basha Fish", "Sliced m utton", "Sliced beef", "Beef tripe", "Chicken kidney", "Shrimp", "Shrim p dumplings", "Crab stick", "Mushroom")
type <- c(3,1,3,1,2,2,2,3,2,2,1,1,2,2,1,1,1,1,1,1,3,3,2)
time_least <- c(0,2,0,1,0,0,1,2,3,3,4,4,4,5,3,3,5,3,6,5,5,5,6) time_most <- c(10,10,5,8,5,3,1,8,3,5,10,8,8,10,6,8,8,5,10,10,10,8,10)
data data
## ##1 ##2 ##3 ##4 ##5 ##6 ##7 ##8 ##9 ## 10 ## 11 ## 12 ## 13 ## 14 ## 15 ## 16 ## 17 ## 18 ## 19 ## 20 ## 21 ## 22 ## 23
<- data.frame(food, type, time_least, time_most)
food type time_least time_most Crispy meat 3 0 10 Squid1210 Luncheonmeat 3 0 5 Egg118
Cucumber 2 Tomato 2 Coriander 2 Dried tofu 3 Sprouts 2 Radish 2 Yellow larynx fillet 1 Meatball 1 Winter melon 2 Seaweed 2 Basha Fish 1 Sliced mutton 1 Sliced beef 1 Beef tripe 1 Chicken kidney 1 Shrimp 1 Shrimp dumplings 3 Crab stick 3 Mushroom 2
0 5 0 3 1 1 2 8 3 3 3 5 4 10 4 8 4 8 5 10 3 6 3 8 5 8 3 5 6 10 5 10 5 10 5 8 6 10
```

