function output =mxColWiseNorm( input )
%--------------------------------------------------------------------------
% 用于对各列进行归一化，方法按照(x-xmin)/(xmax-xmin)
% input input matrix
% output output matrix
%--------------------------------------------------------------------------
colWiseMax=max(input);
colWiseMin=min(input);

col=size(input,2);

output=zeros(size(input));

for i=1:col
   output(:,i)= (input(:,i)-colWiseMin(i))/(colWiseMax(i)-colWiseMin(i));
end
end

