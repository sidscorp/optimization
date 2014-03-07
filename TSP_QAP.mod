/*A quick and simple code written in CPLEX to solve the Travelling Salesman Problem formulated as a Quadratic Assignment Problem */
/*Note that row (n+1) is to ensure that the last constraint is possible to be enforced. */
/*Input the Distance matrix and the value of n in the .dat file which containts the data. */
/*The solution matrix for an n city problem will consist of an (n+1)*(n+1) matrix with the last row and column remaining unused */
int n = ...;
range large = 1..17;
range Rows = 1..n;
range Row1 = 1..(n+1);

float D[large][large] = ...;

dvar boolean x[Row1][Row1];

minimize
  sum(i in Rows) sum(j in Rows) sum(k in Rows) ((D[i][j])*(x[i][k])*(x[j][k+1]));
 
subject to 
{
	forall(j in Rows)
		sum(i in Rows) x[i][j] == 1;
}

subject to 
{
	forall(i in Rows)
		sum(j in Rows) x[i][j] == 1;
}

subject to
{
	forall(i in Rows)
	 ct:
	  	x[i][n+1] == x[i][1];
}
