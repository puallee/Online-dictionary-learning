train =traindatas
train_label = trainlabels
test =testdatas 
test_label =testlabels
[train,pstrain] = mapminmax(train');
pstrain.ymin = 0;
pstrain.ymax = 1;
[train,pstrain] = mapminmax(train,pstrain);
[test,pstest] = mapminmax(test');
pstest.ymin = 0;
pstest.ymax = 1;
[test,pstest] = mapminmax(test,pstest);
train = train';
test = test';
%% 参数初始化
%粒子群算法中的两个参数
c1 = 1.6; % c1 belongs to [0,2]
c2 = 1.5; % c2 belongs to [0,2]
maxgen=300;   % 进化次数 
sizepop=30;   % 种群规模
popcmax=10^(2);
popcmin=10^(-1);
popgmax=10^(3);
popgmin=10^(-2);
k = 0.6; % k belongs to [0.1,1.0];
Vcmax = k*popcmax;
Vcmin = -Vcmax ;
Vgmax = k*popgmax;
Vgmin = -Vgmax ;
% SVM参数初始化 
v = 3;
%% 产生初始粒子和速度
for i=1:sizepop
    % 随机产生种群
    pop(i,1) = (popcmax-popcmin)*rand+popcmin;    % 初始种群
    pop(i,2) = (popgmax-popgmin)*rand+popgmin;
    V(i,1)=Vcmax*rands(1);  % 初始化速度
    V(i,2)=Vgmax*rands(1);
    % 计算初始适应度
    cmd = ['-v ',num2str(v),' -c ',num2str( pop(i,1) ),' -g ',num2str( pop(i,2) )];
    fitness(i) = svmtrain(train_label, train, cmd);
    fitness(i) = -fitness(i);
end
% 找极值和极值点
[global_fitness bestindex]=min(fitness); % 全局极值
local_fitness=fitness;   % 个体极值初始化
global_x=pop(bestindex,:);   % 全局极值点
local_x=pop;    % 个体极值点初始化
tic
%% 迭代寻优
for i=1:maxgen
   
    for j=1:sizepop
       
        %速度更新
        wV = 0.9; % wV best belongs to [0.8,1.2]
        V(j,:) = wV*V(j,:) + c1*rand*(local_x(j,:) - pop(j,:)) + c2*rand*(global_x - pop(j,:));
        if V(j,1) > Vcmax
            V(j,1) = Vcmax;
        end
        if V(j,1) < Vcmin
            V(j,1) = Vcmin;
        end
        if V(j,2) > Vgmax
            V(j,2) = Vgmax;
        end
        if V(j,2) < Vgmin
            V(j,2) = Vgmin;
        end
       
        %种群更新
        wP = 0.6;
        pop(j,:)=pop(j,:)+wP*V(j,:);
        if pop(j,1) > popcmax
            pop(j,1) = popcmax;
        end
        if pop(j,1) < popcmin
            pop(j,1) = popcmin;
        end
        if pop(j,2) > popgmax
            pop(j,2) = popgmax;
        end
        if pop(j,2) < popgmin
            pop(j,2) = popgmin;
        end
       
        % 自适应粒子变异
        if rand>0.5
            k=ceil(2*rand);
            if k == 1
                pop(j,k) = (20-1)*rand+1;
            end
            if k == 2
                pop(j,k) = (popgmax-popgmin)*rand+popgmin;
            end           
        end
       
        %适应度值
        cmd = ['-v ',num2str(v),' -c ',num2str( pop(j,1) ),' -g ',num2str( pop(j,2) )];
        fitness(j) = svmtrain(train_label', train, cmd);
        fitness(j) = -fitness(j);
    end
   
    %个体最优更新
    if fitness(j) < local_fitness(j)
        local_x(j,:) = pop(j,:);
        local_fitness(j) = fitness(j);
    end
   
    %群体最优更新
    if fitness(j) < global_fitness
        global_x = pop(j,:);
        global_fitness = fitness(j);
    end
   
    fit_gen(i)=global_fitness;   
       
end
toc
%% 结果分析
plot(-fit_gen,'LineWidth',5);
title(['适应度曲线','(参数c1=',num2str(c1),',c2=',num2str(c2),',终止代数=',num2str(maxgen),')'],'FontSize',13);
xlabel('进化代数');ylabel('适应度');
bestc = global_x(1)
bestg = global_x(2)
bestCVaccuarcy = -fit_gen(maxgen)
cmd = ['-c ',num2str( bestc ),' -g ',num2str( bestg )];
model = svmtrain(train_label,train,cmd);
[trainpre,trainacc] = svmpredict(train_label,train,model);
trainacc
[testpre,testacc] = svmpredict(test_label,test,model);
testacc
 