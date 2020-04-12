function [B, S, stat] = do_sparse_coding(X, D_size, eye, beta, gamma, num_iters, batch_size, initB)
% This is the Regularized sparse coding learning,include Two optimization
%one:use Dictionary to got the Sparse Coefficient
% minimize_s 0.5*||y - A*x||^2 + gamma*||x||_1
% A=B'*B+2*beta*eye(Sc.Codebook_Size)
% x=-B'*X(:,i)
% two: if the Sparse Coefficient is known
%    minimize_B   0.5*||X - B*S||^2
%    subject to   ||B(:,j)||_2 <= l2norm, forall j=1...size(S,1)
%% parameters
pars = struct;
pars.patch_size = size(X,1);
pars.num_patches = size(X,2);
pars.num_bases = D_size;
pars.num_trials = num_iters;
pars.beta = beta;
pars.gamma = gamma;
pars.VAR_basis = 1; % maximum L2 norm of each dictionary atom

if ~isa(X, 'double'),%判断X是否为double型
    X = cast(X, 'double');%强制转换为double型
end
if exist('batch_size', 'var') && ~isempty(batch_size)%batch_size是否存在
    pars.batch_size = batch_size; 
else
    pars.batch_size = size(X, 2);%34980
end
% initialize basis
if ~exist('initB') || isempty(initB)
    B = rand(pars.patch_size, pars.num_bases)-0.5;%pars.patch_size = size(X,1);pars.num_bases = num_bases;
	B = B - repmat(mean(B,1), size(B,1),1);
    B = B*diag(1./sqrt(sum(B.*B)));
    %% B为稀疏矩阵，没有一个0
else
    disp('Using initial B...');
    B = initB;
end
%% done
[L M]=size(B);
t=0;
% statistics variable
stat= [];
stat.fobj_avg = [];
stat.elapsed_time=0;
stat.fresidue_avg=[];
% optimization loop
while t < pars.num_trials%pars.num_trials = num_iters;为50
    t=t+1;
    start_time= cputime;
    stat.fobj_total=0;   
    stat.fresidue=0;
    % Take a random permutation of the samples
indperm = randperm(size(X,2))
sparsity = [];
   for batch=1:(size(X,2)/pars.batch_size),% pars.batch_size = batch_size
        % This is data to use for this step
        batch_idx = indperm((1:pars.batch_size)+pars.batch_size*(batch-1));
        Xb = X(:,batch_idx);
        %打乱
        %Use feature sign algorithm
        S = L1QP_FeatureSign_Set(Xb, B,eye, pars.beta, pars.gamma);
        sparsity(end+1) = length(find(S(:) ~= 0))/length(S(:));
        % get objective                   
       [fobj,fresidue] = getObjective_RegSc(Xb, B, S, eye, pars.beta, pars.gamma);
        %实验数据：
        %  fobj =7.6060e-3，
        % sparsity =0.0132
        % fresidue  重构误差
       disp([t,fobj,fresidue]);
     stat.fobj_total = stat.fobj_total + fobj;%=0+7.6060e+04
     stat.fresidue=stat.fresidue+fresidue
        % learn coefficients (conjugate gradient)   共轭梯度法
        % update basis，By Andrew Ng
      B = l2ls_learn_basis_dual(Xb, S, pars.VAR_basis);
   %||B(:,j)||_2 <=约束量pars.VAR_basis=1;通过稀疏系数和信号来求字典，所以误差重构项  minimize_B   0.5*||X - B*S||^2
   %;Lagrange对偶问题，这里采用Newton's method or conjugate gradient
 end
 % get statistics
    stat.fobj_avg(t)      = stat.fobj_total / pars.num_patches;
    stat.fresidue_avg(t)=stat.fresidue/pars.num_patches
    stat.elapsed_time(t)  = cputime - start_time;
    fprintf(['epoch= %d, sparsity = %f, fobj= %f, took %0.2f ' ...
             'seconds\n'], t, mean(sparsity), stat.fobj_avg(t), stat.elapsed_time(t));
end
return



