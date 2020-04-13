for i=1:pso_option_maxgen;
 for j=1:pso_option_sizepop;
cmd=['-v',num2str(pso_option.v),'-c',num2str(pop(j,1),'-g',numstr(pop(j,2)),'-a',num2str(pop(j,3)) ];
    fitness(j)=svmtrain(train_label,train,cmd);
    if fitness(j)>local_fitness(j)
    local_x(j,:)=pop(j,:);
    end
    if firness(j)<global_fitness(j)
        global_x=pop(j,:);
        global_fitness=fitness(j);
    end
 end

