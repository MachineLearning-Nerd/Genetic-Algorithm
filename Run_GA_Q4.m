%% Basic binary GA algorithnm for finding the minimum of F(x,y) 
%% Sean McLoone, 3rd July 2020
%%

clc
close all; clear all;

SN=40277854;  %enter your student number here

visflag=1;  % 1 to display plots at each generation, 0 to run faster

% elite_no = 2:2:10;

for elite_no = [2 5 8]
    for gen_max_val = [10, 20, 50, 100]
        %% Display plot of function F(x,y)
        figure(1); clf
        [Zmin Xmin Ymin]=plt_surf(8,SN);

        %% GA user defined parameters
        gen_max=gen_max_val; 
        pop_size=round(1000/gen_max_val);
        mating_pairs=pop_size;
        mut_rate=0.1;

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
            [best_pop, best_score, pop_sel, pop_scoreval] = elite_selection(pop, pop_score, elite_no);

            % [par1 par2] = select_parents(pop, pop_score, mating_pairs);
            % [offspring_XVR] = crossover_binary_parents(par1,par2);
            % [offspring_MUT] = calc_binary_mutation(offspring_XVR, mut_rate);

            mating_pairs = pop_size - 5;
            [par1, par2] = select_parents(pop_sel, pop_scoreval, mating_pairs);
            [offspring_XVR] = crossover_binary_parents(par1, par2);
            [offspring_MUT] = calc_binary_mutation(offspring_XVR, mut_rate);

            % add validity check here if needed

            %retain best offspring to be next generation

            pop_score=calc_binary_fitness(offspring_MUT,SN);

            [order_score, order_index]=sort(pop_score, 'ascend');
            

            pop=offspring_MUT(order_index(1:pop_size-elite_no),:);
            pop_score=order_score(1:pop_size-elite_no);
            
            
            pop_score = [pop_score; best_score];
            pop = [pop; best_pop];
            scoreS = [scoreS; min(pop_score)];

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
        saveas(gcf, ['Q4analysis/Surface_mut_' num2str(gen_max_val) '_' num2str(elite_no) '.png'])
        %%
        figure(3); clf;
        g=1:1:length(scoreS);
        plot(g,scoreS,'o'); hold on
        plot(g,scoreS,'r');
        plot([g(1) g(end)],[Zmin Zmin],'k:');
        set(gca,'Xlim',[g(1) g(end)]);
        xlabel('generation no');
        ylabel('Min F(x,y) at each generation')
        title(['For Gen-Max', num2str(gen_max_val), ' elite(k):' num2str(elite_no)])
        saveas(gcf, ['Q4analysis/Analysis_mut_' num2str(gen_max_val) '_' num2str(elite_no) '.png'])

        act_sol=[Zmin Xmin Ymin];
        ga_best=[zGAmin xGAmin yGAmin];
        ga_fin=[zGAfin xGAfin yGAfin];
    end
end

%% Elite selection:
function [min_pop_SEL, min_score, pop_SEL, pop_score] = elite_selection(pop, pop_score, elite_no)
  % [max_pops, i] = maxk(pop_score, elite_no);
  [min_pops, i] = mink(pop_score, elite_no);
  min_pop_SEL = pop(i, :);
  min_score = min_pops;

  [sorted_pop_score, i]= sort(pop_score);
  pop_SEL = pop(i(elite_no+1:(length(pop_score))),:);
  pop_score = sorted_pop_score(elite_no+1:(length(pop_score)));
end