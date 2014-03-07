A = [...
0 0 0 2 0 0 0 6 3;
3 0 0 0 0 5 4 0 1;
0 0 1 0 0 3 9 8 0;
0 0 0 0 0 0 0 9 0;
0 0 0 5 3 8 0 0 0;
0 3 0 0 0 0 0 0 0;
0 2 6 3 0 0 5 0 0;
5 0 3 7 0 0 0 0 8;
4 7 0 0 0 1 0 0 0];
 
origin=[];
for i=1:81
    if (A(i) ~= 0) origin = [origin; mod(i-1,9)+1 ceil(i/9) A(i)];
    end
end

    g=size(origin,1);


n = 9;

Aeq=zeros(4*n^2, n^3);

for i=1:n^2
    Aeq(i,(i-1)*n+1:i*n)=ones(1,n);
end

for k=1:n
    for i=1:n
        for j=1:n
            Aeq(n^2+i+(k-1)*n,1+(i-1)+(j-1)*n+(k-1)*n^2)=1;
        end
    end
end

for m=1:sqrt(n)
    for l=1:sqrt(n)
        for j=1:n
            for k=1:sqrt(n)
              Aeq(2*n^2+(m-1)*sqrt(n)*n+(l-1)*n+j,(j-1)*n^2+(l-1)*sqrt(n)+(m-1)*sqrt(n)*n+(k-1)*n+1:(j-1)*n^2+(l-1)*sqrt(n)+(m-1)*sqrt(n)*n+(k-1)*n+sqrt(n))=1;
            end
        end
    end
end

for i=1:n
    for j=1:n
        for k=1:n
          Aeq(3*n^2+(i-1)*n+j,(i-1)*n+j + (k-1)*n^2)=1;
        end
    end
end

for i=1:g
    Aeq(4*n^2+i,origin(i,1)+(origin(i,2)-1)*n+(origin(i,3)-1)*n^2)=1;
end
    
beq=ones(4*n^2+g,1);
tic
options.MaxRLPIter=500000;
[x,fval,exitflag,output]=bintprog(zeros(n^3,1),[],[],Aeq,beq,[],options);
exitflag;
output;
display('The time taken to solve this puzzle was')
toc
x; 

S=zeros(n,n);
for k=1:n
  substitute=find(x((k-1)*n^2+1:k*n^2));
  for j=1:n
      row=mod(substitute(j),n);
      if row==0
          row=n;
      end
      S(row,j)=k;
  end
end

display('The original Question was')
A
display('The solution of the above question is')
S
