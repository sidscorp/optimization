/*This is the conventional TSP solution that you should find fairly commonly all over ther internet and in text books.*/
/*Written in CPLEX, this solves an n city TSP problem after generating distance data randomly. Note that the data file should contain the value of n

int n = ...;
range cities = 1..n;

tuple location{
	float x;
	float y;
}

tuple edge{
	int i;
	int j;
}

setof(edge) edges = {<i,j> | i, j in cities : i!=j};
float c[edges] ;
location cityLocation[cities];

execute{
	function getDistance(city1, city2) {
		return Opl.sqrt(Opl.pow(city1.x - city2.x, 2) + Opl.pow(city1.y - city2.y, 2));	
	}	
	for (var i in cities) {
		cityLocation[i].x = Opl.rand(100);
		cityLocation[i].y = Opl.rand(100);
	}
	for (var e in edges) {
		c[e] = getDistance(cityLocation[e.i], cityLocation[e.j]);
	}			
}

dvar boolean x[edges];
dvar float+ u[2..n];

dexpr float TotalDistance = sum(e in edges) c[e]*x[e];
 	
minimize TotalDistance;

subject to{
	forall(j in cities)
	  flow_in:
	  sum(i in cities : i!=j) x[<i,j>] == 1;
	
	forall(i in cities)
	  flow_out:
	  sum(j in cities : i!=j) x[<i,j>] == 1;
	  
	forall(i in cities : i>1, j in cities : j>1 && j!=i )
	  subtour:
		  u[i] - u[j] + (n-1)*x[<i,j>] <= n-2;
	  
}

main {
	var mod = thisOplModel.modelDefinition;
	var dat = thisOplModel.dataElements;
	for ( var size = 5; size < 40; size+=5) {
		var MyCplex = new IloCplex();
		var opl = new IloOplModel(mod,MyCplex);	
		dat.n=size;
		opl.addDataSource(dat);
		opl.generate();
		if (MyCplex.solve()) {
				writeln("solution: ", MyCplex.getObjValue(),
				" /size: ", size,
				" /time: ", MyCplex.getCplexTime());
 }
 opl.end()
 MyCplex.end()
 			
		}
	}
