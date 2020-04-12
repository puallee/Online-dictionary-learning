function  [Err,Odata,A01]=a_B_restruction(data_tran,B,Scode,scale,data_all)
BB=B';
%i=1:size(Scode,2);
%ma=find(Scode(:,i)~=0);
%Bb=BB(ma',:);
%weight=[];
%weight=k(ma);
%for j=1:size(weight,1);
%Bb(j,:)=Bb(j,:).*weight(j);
%end
%Odata=sum(Bb,1);
%A0 = idwt(Odata,[],'db3');
Odatas=Scode'*BB;
for i=1:55;
Odatas1(i,:)=Odatas(i,1:17)*scale(i,1);
Odatas2(i,:)=Odatas(i,18:34)*scale(i,2);
end
for j=1:55
  Odata11(j,:)=idwt(Odatas1(j,:),Odatas2(j,:),'db3');
end
%去归一化；
for ii=1:55;
    Odata(ii,:)= Odata11(ii,:)*scale(ii,4)+scale(ii,3)
end
Oda=[];
for i=1:54
  Odat= Odata(i,1:5)
  Oda=[Oda,Odat];
end
Odat= Odata(55,1:30);
Oda=[Oda,Odat];
%% data_tran的数据
for j=1:55
A011(j,:) = idwt(data_tran(j,1:17)*scale(j,1),data_tran(j,18:34)*scale(j,2),'db3')
end
for jj=1:55
    A01(jj,:)=A011(jj,:)*scale(jj,4)+scale(jj,3)
end
D01=[];
for i=1:54
  A02= A01(i,1:5)
  D01=[D01,A02];
end
A02= A01(55,1:30);
D01=[D01,A02];
t=1:300;
figure(1);
plot(t,Oda,'r',t,data_all,'g');
figure(2)
plot(t,Oda,'r',t,D01,'b');
%重构误差
Err=norm(Oda-data_all)/norm(data_all)    
end


%DO1= idwt(data_tran{1}{1}(j,18:34),data_tran{1}{1}(1,18:34),'db3');

%t=1:1:30;
%plot(t,A0,'r',t,A01,'m')
%A0ss=[];
%for j=1:55;
 %A0s = idwt(Odatas(j,:),[],'db3');
 %A0ss=[A0ss;A0s]
%end
% load('grid.mat')
 %AAs=[];
 %for i=1:54;
%5AA=A0ss(i,1:5)
%AAs=[AAs,AA];
 %end
 %AAs=[AAs,A0ss(55,1:30)]
%D0ss=[];
%for j=1:55;
% D0s = idwt(data_tran{1}{1}(j,:),[],'db3');
% D0ss=[D0ss;D0s]
%end
 %DDs=[];
 %for i=1:54;
%DD=D0ss(i,1:5)
%DDs=[DDs,DD];
% end
 %DDs=[DDs,D0ss(55,1:30)]
% t=1:1:300;
%plot(t,AAs,'r',t,DDs,'m')