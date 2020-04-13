%随机取30个作为训练数据，其他的预测；
%共9类，每类462个
%train，30，test，432；
load('data.mat')
traindata=[];
testdata=[];
for i=1:9
index=randperm(462);
index=(i-1)*462+index;
 traindata(:,(i-1)*30+1:(i-1)*30+30)=data(:,index(1:30));
 testdata(:,(i-1)*432+1:(i-1)*432+432)=data(:,index(31:462));
end