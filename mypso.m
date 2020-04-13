function [bestC,bestsig,besterr] = mypso(X,Y,trainlabel,trainlabel1);

bestC = zeros(1,2);
bestsig = zeros(1,2);
besterr = zeros(1,2);
y_dim = size(Y,2);

for dim=1:y_dim,
% 参数初始化

%粒子群算法中的两个参数
c1 = 1.6; % c1 belongs to [0,2] c1:初始为1.5,pso参数局部搜索能力
c2 = 1.7; % c2 belongs to [0,2] c2:初始为1.7,pso参数全局搜索能力

maxgen=50; % 进化次数 
sizepop=5; % 种群规模

popcmax=10^(2); % popcmax:初始为1000,SVM 参数c的变化的最大值.
popcmin=10^(-1); % popcmin:初始为0.1,SVM 参数c的变化的最小值.
popgmax=10^(2); % popgmax:初始为1000,SVM 参数g的变化的最大值
popgmin=10^(-1); % popgmin:初始为0.01,SVM 参数c的变化的最小值.
k = 0.2; % k belongs to [0.1,1.0];
Vcmax = k*popcmax;%参数 c 迭代速度最大值  20
Vcmin = -Vcmax ;%-20
Vgmax = k*popgmax;%参数 g 迭代速度最大值  20
Vgmin = -Vgmax ; %-20

eps = 10^(-3);

% 产生初始粒子和速度
for i=1:sizepop%5

% 随机产生种群
pop(i,1) = (popcmax-popcmin)*rand(1,1)+popcmin ; % 初始种群 (100-0.1)*rand(1,1)+0.1
pop(i,2) = (popgmax-popgmin)*rand(1,1)+popgmin;  %(100-0.1)*rand(1,1)+0.1
V(i,1)=Vcmax*rands(1,1); % 初始化速度 20*rands(1,1);
V(i,2)=Vgmax*rands(1,1); % -20*rans(1,1);

% 计算初始适应度
gam = pop(i,1);
sig2 = pop(i,2);

%求出训练集和测试集的预测值

%fitness(i) = fcrossvalidatelssvm(X,'RBF_kernel',gam, sig2 ,Y(:,dim), 5 ,'mae');%交叉验证
traindata=X;
traindata1=Y;
model = svmtrain(trainlabel'traindata -s 0 -t 2 -c gam -g sig2');
[ptrain,acctrain,decision] = svmpredict(trainlabel1,traindata1,model);
fitness(i)=acctrain(i);
end

% 找极值和极值点
[global_fitness ,bestindex]=min(fitness); % 全局极值
local_fitness = fitness; % 个体极值初始化 

global_x = pop(bestindex,:); % 全局极值点
local_x = pop; % 个体极值点初始化

% 每一代种群的平均适应度
avgfitness_gen = zeros(1,maxgen);%1*50

tic

% 迭代寻优
for i=1:maxgen%50

for j=1:sizepop% 5

%速度更
wV = 1; % wV best belongs to [0.8,1.2]为速率更新公式中速度前面的弹性系数
V(j,:) = wV*V(j,:) + c1*rand*(local_x(j,:) - pop(j,:)) + c2*rand*(global_x - pop(j,:));
if V(j,1) > Vcmax %以下几个不等式是为了限定速度在最大最小之间
V(j,1) = Vcmax;
end
if V(j,1) < Vcmin
V(j,1) = Vcmin;
end
if V(j,2) > Vgmax
V(j,2) = Vgmax;
end
if V(j,2) < Vgmin
V(j,2) = Vgmin; %以上几个不等式是为了限定速度在最大最小之间
end

%种群更新
wP = 1; % wP:初始为1,种群更新公式中速度前面的弹性系数
pop(j,:)=pop(j,:)+wP*V(j,:);
if pop(j,1) > popcmax %以下几个不等式是为了限定 c 在最大最小之间
pop(j,1) = popcmax;
end
if pop(j,1) < popcmin
pop(j,1) = popcmin;
end
if pop(j,2) > popgmax %以下几个不等式是为了限定 g 在最大最小之间
pop(j,2) = popgmax;
end
if pop(j,2) < popgmin
pop(j,2) = popgmin;
end


%个体最优更新
if fitness(j) < local_fitness(j)
local_x(j,:) = pop(j,:);
local_fitness(j) = fitness(j);
end

if abs( fitness(j)-local_fitness(j) )<=eps && pop(j,1) < local_x(j,1)
local_x(j,:) = pop(j,:);
local_fitness(j) = fitness(j);
end 

%群体最优更新
if fitness(j) < global_fitness
global_x = pop(j,:);
global_fitness = fitness(j);
end

if abs( fitness(j)-global_fitness )<=eps && pop(j,1) < global_x(1)
global_x = pop(j,:);
global_fitness = fitness(j);
end
end
fit_gen(i)=global_fitness; 
avgfitness_gen(i) = sum(fitness)/sizepop;

end

toc

bestC(dim) = global_x(1);
bestsig(dim) = global_x(2);
besterr(dim) = fit_gen(maxgen);


%打印信息
fprintf('\n')
disp(['         粒子群算法结果:  [C]         ' num2str(bestC(dim))]);
disp(['                      [sig2]       ' num2str(bestsig(dim))]);
disp(['                      error=       ' num2str(besterr(dim))]);
disp(' ')

end