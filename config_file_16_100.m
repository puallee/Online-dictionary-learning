%%% Configuration file:
%%% DIRECTORIES - This is the directories for the whole programs
%% Directory holding all the experiment original signals
DATA_DIR = './data/original_data/';
%% Directory holding the codebook,or the other signal feature parameters i.e. grid  scale
CODEBOOK_DIR = './data/codebook/';
%% Feature directory - holds all features, include Scode
FEATURE_DIR = './data/feature/';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% dataset parameters 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% number of classes 
num_class = 9;
%% Transform
transform = 'wavelet';
%% length of subsequences
sub_length = 30;
%% over points between slideing window
inter_point = 5;
%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Sparse codebook parameters 
%%%%%%%%%%%%%%%%%%%%%%%%%%
% minimize_s 0.5*||y - A*x||^2 + gamma*||x||_1
% A=B'*B+2*beta*eye(Sc.Codebook_Size)
% x=-B'*X(:,i)
%% size of Sparse codebook
Sc.Codebook_Size = 100;
%% Max number of  iterations
Sc.Max_Iterations = 100;
%% Verbsoity of Mark's code
Sc.Verbosity = 0;
%% a small regularization parameter for stablizing
beta=1e-5;
%% pooling parameter;
pyramid=[1,2,4];%½ð×ÖËþ
gamma=0.15;%ÖØ¹¹Îó²î
%% Maximum correlation
knn=20;
