function [sc_codes,Histogram] = get_non_Coeff(config_file)
%% Evaluate global configuration file
try
    eval(config_file);
catch
    disp('config file failed!')
end
load([FEATURE_DIR,'data_tran.mat']);
load([CODEBOOK_DIR,'Scode','_', num2str(Sc.Codebook_Size), '.mat']);
load([CODEBOOK_DIR,'grids.mat']);

%% pooling parameter;
pyramid=[1,2,4];
gamma=0.15;
knn=20;% Maximum correlation
%signal_patchs=[];
for i=1:size(data_tran,2);
 for j=1:size(data_tran{i},2);
        disp('Sc_pooling');
         disp([i,j]);
 [sc_codes{i}{j},Histogram{i}{j}] =signal_pooling(data_tran{i}{j},B,pyramid,gamma,knn,grids)
 %signal_patchs=[signal_patchs;signal_patch];
 end
end
savepath = [FEATURE_DIR,'Histogram','_',num2str(Sc.Codebook_Size),'.mat'];
save(savepath,'Histogram');
savepaths = [FEATURE_DIR,'sc_codes','.mat'];
save(savepaths,'sc_codes');
end

