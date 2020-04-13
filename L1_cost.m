function cost=L1_cost(y,B,x,lambda)
    tmp = y-B*x;
    cost = tmp'*tmp+lambda*norm(x,1);
return
