proc optmodel;
	/* declare sets and parameters */
	set <str> RESOURCES  = /wheat barley soyabean/;
	set <str> PRODUCTS = /Sweetmix Proteinrich/;
	num profit {PRODUCTS} = [1.5 3];
	num availability {RESOURCES} = [100 250 50];
	num required {PRODUCTS, RESOURCES} = [
		0.5 0.4 0.1
		0.25 0.5 0.25
		];

	/* declare variables */
	var NumProd {PRODUCTS} >= 0;
	impvar AmountUsed {r in RESOURCES} = 
		sum {p in PRODUCTS} NumProd[p] * required[p,r];
	impvar PercentUtilization {r in RESOURCES} = ( AmountUsed[r] / availability[r] );

	/* declare constraints */
	con Usage {r in RESOURCES}: 
		AmountUsed[r] <= availability[r];

	/* declare objective */
	max NetProfit = sum {p in PRODUCTS}
		profit[p] * NumProd[p];

	/*Print LP formulation*/
	expand NetProfit;
	expand / var impvar;

	/*Solve LP*/
	solve with lp / algorithm=ps logfreq=1;
	print 'Profit:' (NetProfit) dollar.;
	print 'Production Plan'  {i in PRODUCTS: NumProd[i]>0} NumProd;
	print 'Resouce Usage:' AmountUsed 
		Availability 
		PercentUtilization percent7.1
		Usage.dual;
 
quit;

/*Assignment 1 question 1 part 2 (Adapted from Kexiang Huang 18035793)*/

proc optmodel;
 set RESOURCES = /wheat barley soyabean maize/;
 set PRODUCTS = /Sweetmix Proteinrich Firstfeed/;
 set NUTRITIONS = /Carbohydrate Protein/;
 num selling_price {PRODUCTS} = 
 [1.84 3.45 2.50];
 num availability {RESOURCES} = 
 [100 250 50 550];
 num cost{RESOURCES} = 
 [0.2 0.4 0.8 0.5];
 num contents {NUTRITIONS,RESOURCES} = 
 [0.8 0.8 0.5 0.6
 0.05 0.1 0.25 0.1];

/* make desition variables*/
 var comproduct{PRODUCTS, RESOURCES} >= 0;

 impvar NumProd {i in PRODUCTS} = sum{j in RESOURCES} comproduct[i,j];
 impvar AmountUsed{i in RESOURCES} = sum{j in PRODUCTS} comproduct[i,j];
 impvar Revenue = sum{i in PRODUCTS} NumProd[p] * selling_price[i];
 impvar TotalCost = sum{j in RESOURCES} AmountUsed[j] * cost[j];
 impvar Carbohydrate{p in PRODUCTS} = sum {j in RESOURCES} comproduct[i,j] * contents['Carbohydrate',j];
 impvar Protein{p in PRODUCTS} = sum {j in RESOURCES} comproduct[i,j] * contents['Protein',j];
 impvar productcomp{p in PRODUCTS, j in resources} = comproduct[i,j] / NumProd[i];
 impvar CarbohydratePercentage {i in PRODUCTS} = Carbohydrate[j] / NumProd[i];
 impvar ProteinPercentage {i in PRODUCTS} = Protein[i] / NumProd[i];

/* Objective function*/
 max Profit = Revenue - TotalCost;

/* Setup Constainst*/
 con Usage{r in RESOURCES}: AmountUsed [r] <= availability[r];
 con NumProd['Firstfeed'] = 50;
 con Carbohydrate['Sweetmix']  >= 0.7*NumProd['Sweetmix'];
 con  NumProd['Sweetmix']*0.05 <= Protein['Sweetmix'] ;
 con  0.3*NumProd['Sweetmix'] >= Protein['Sweetmix'] ;
 con Carbohydrate['Proteinrich']  >= 0.6*NumProd['Proteinrich'];
 con 0.15*NumProd['Proteinrich'] <= Protein['Proteinrich'] ;
 con Protein['Proteinrich']  <= 0.4*NumProd['Proteinrich'];
 con Carbohydrate['Firstfeed']  >= 0.6* NumProd['Firstfeed'];
 con 0.1 * NumProd['Firstfeed'] <= Protein['Firstfeed'] ;
 con  Protein['Firstfeed'] <= 0.15* NumProd['Firstfeed'];
 solve;

 print 'Profit:' Profit dollar8.2;
 print 'Product receip:' productcomp percent7.2 ;
 print 'Nutritionl list:' CarbohydratePercentage percent5.2 ProteinPercentage percent5.2;
 print 'Product contains:' comproduct;
 print 'Production Plan:' NumProd;
 print 'Useage of Resources and reduced cost:' availability AmountUsed Usage.dual Usage.status;
 print _VAR_.name _var_  _VAR_.rc _var_.status  _VAR_.lb _VAR_.ub _VAR_.sol;
 print _CON_.name _CON_.body  _CON_.lb _CON_.ub _CON_.dual _CON_.status;


