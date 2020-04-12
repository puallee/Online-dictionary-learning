function [sc_codes,signal_patch] = signal_pooling(X, B, pyramid, gamma, knn,grids)
%================================================
%% 非负字典表述

dSize = size(B, 2);%100
nSmp = size(X, 1);%55
signal_length = grids.tol(2),%300
%idxBin = zeros(nSmp, 1);%55x1 double
sc_codes = zeros(dSize, nSmp);%100x55 double
% compute the local feature for each local feature
D = X*B;%图片与字典相乘，55*17*17*100=55*100
IDX = zeros(nSmp, knn);%55x200 double
for ii = 1:nSmp,%55
	d = D(ii, :);%d=1*100
	[dummy, idx] = sort(d, 'descend');%降序排列，dummy1*100，idx1*100
	IDX(ii, :) = idx(1:knn);%把idx降序排列的前20个
end
%IDX最后变为55*20,20为idx
for ii = 1:nSmp,%55
    y = X(ii,:)';%17*1
    idx = IDX(ii, :);%取20，把idx拿出来,1*20
    BB = B(:, idx);%100个单词的字典按idx降序排列的前20个。17*20，可以理解为字典和图片相乘后，只有每个SIFT，这前20个单词有关，后面不计
    sc_codes(idx, ii) = feature_sign(BB, y, 2*gamma);% 2*gamma=0.3
    %引用了Andrew Ng的L1范数求解，共轭梯度法求解；
end
sc_codes = abs(sc_codes);
%% pooling,字典直方图表述
grids.f=sc_codes;%加入到结构体中
% Times levels
pLevels = length(pyramid);%3
tBins = sum(pyramid);%1+2+4=7
signal_patch = zeros(dSize, tBins);%100x7 double
bId = 0;
pat=1;
c=1;
grids.x=grids.x+15;
for iter1 = 1:pLevels,%3
   if iter1==3;
       c=0;
    end
   nBins = pyramid(iter1);%1,2,4;
  for i=1:pat;
   x_l=floor(signal_length/pat*(i-1));
   x_h=floor(signal_length/pat*i);
   signal_patch(:,i+iter1-c)=max(grids.f(:,(grids.x>x_l)&(grids.x<x_h)),[],2);
   end
   pat=pat*2;
end
%% signal_patch为直方图表示，max时失去了一部分信息；时间金字塔匹配一定程度上保留了相应的时间信息
%% sc_codes为该信号的非负数稀疏表示，保留了完整的信号特征。


