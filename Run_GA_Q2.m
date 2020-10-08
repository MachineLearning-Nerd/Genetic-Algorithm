%% Basic binary GA algorithnm for finding the minimum of F(x,y) 
%% Sean McLoone, 3rd July 2020
%%

clc
close all; clear all;
addpath('Q2analysis')
SN=40277854;  %enter your student number here

visflag=1;  % 1 to display plots at each generation, 0 to run faster

for mut_rat = 0:0.1:1
    %% Display plot of function F(x,y)
%     if visflag == 1
        figure(1); clf
        [Zmin Xmin Ymin]=plt_surf(8,SN);
%     end
    %% GA user defined parameters
    gen_max=30; 
    pop_size=20;
    mating_pairs=pop_size;
    % mut_rate=0.1;
    mut_rate=mut_rat;

    %Initialise Population;

    % Encode problem variables as a binary chromosome of
    % appropriate number and generate an initial population of chromosomes.


    pop_init = initialise_binary_pop(pop_size);

    pop=pop_init;
    pop_score=calc_binary_fitness(pop,SN);

    %record best score acheived at each generation
    [best_score Cindex] = max(pop_score);
    scoreS =  best_score;

    %Keep track of the best chromsome value at each generation
    [xb,yb]=decode_binary_chromosome(pop(Cindex,:));
    xS=xb;  yS=yb;

    % visualise problem id visflag has been set

    if visflag ==1
        figure(2); clf
        [Zmin Xmin Ymin]=plt_surf(8,SN);
        view(0,90)
        [xinit0,yinit0]=decode_binary_chromosome(pop_init);
        zinit0=calc_binary_fitness(pop,SN);
        hndl=plot3(xinit0,yinit0,zinit0,'g.');

        title('Gen=0')
        pause(1)
    end
        
    %%  
    for gen = 1:gen_max    

        % create new population by applying selection and genetic operators

        [par1 par2] = select_parents(pop, pop_score, mating_pairs);
        [offspring_XVR] = crossover_binary_parents(par1,par2);
        [offspring_MUT] = calc_binary_mutation(offspring_XVR, mut_rate);

        % add validity check here if needed

        %retain best offspring to be next generation

        pop_score=calc_binary_fitness(offspring_MUT,SN);

        [order_score order_index]=sort(pop_score, 'ascend');

        pop=offspring_MUT(order_index(1:pop_size),:);
        pop_score=order_score(1:pop_size);

        scoreS = [scoreS; order_score(1)];

        [xb,yb]=decode_binary_chromosome(pop(1,:));
        xS=[xS ;xb];  yS=[yS; yb];

        if visflag ==1    
            [xinit,yinit]=decode_binary_chromosome(pop);
            zinit=calc_binary_fitness(pop_init,SN);
            delete(hndl);
            hndl=plot3(xinit,yinit,zinit,'g.');
            title(sprintf('Gen =%d',gen))
            pause(1)
        end

    end
    


    [zGAmin idmin]=min(scoreS);

    xGAmin=xS(idmin);
    yGAmin=yS(idmin);

    zGAfin=scoreS(end);
    xGAfin=xS(end);
    yGAfin=yS(end);

    if visflag==1
        hndl0=plot3(xinit0,yinit0,zinit0,'g.');
        delete(hndl);
        hndl=plot3(xinit,yinit,zinit,'ro');

    plot3(xS,yS,scoreS,'ks','MarkerSize',4,'MarkerFaceColor','r');
    legend('Surface', 'optimum','Init Gen','Final Gen','Best at each gen','Location', 'NorthEastOutside')
    end
    saveas(gcf, ['Q2analysis/Surface_mut_' num2str(uint8(mut_rat*10)) '.png'])
    %%
%     figure(3); clf;
    figure,
    g=1:1:length(scoreS);
    plot(g,scoreS,'o'); hold on
    plot(g,scoreS,'r');
    plot([g(1) g(end)],[Zmin Zmin],'k:');
    set(gca,'Xlim',[g(1) g(end)]);
    xlabel('generation no');
    ylabel('Min F(x,y) at each generation')
    title(['For Mutation-rate', num2str(mut_rat)])
    saveas(gcf, ['Q2analysis/Analysis_mut_' num2str(uint8(mut_rat*10)) '.png'])
    act_sol=[Zmin Xmin Ymin]
    ga_best=[zGAmin xGAmin yGAmin]
    ga_fin=[zGAfin xGAfin yGAfin]
end