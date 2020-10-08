%% Basic binary GA algorithnm for finding the minimum of F(x,y) 
%% Sean McLoone, 3rd July 2020
%%

clc
close all; clear all;

SN=40277854;  %enter your student number here

visflag=1;  % 1 to display plots at each generation, 0 to run faster

for gen_max_val = [10, 20, 25, 40, 50, 100]
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


    pop_init = realvalued_initialization_pop(pop_size);

    pop=pop_init;
    pop_score=realvalued_calc_binary_fitness(pop,SN);

    %record best score acheived at each generation
    [best_score Cindex] = max(pop_score);
    scoreS =  best_score;

    %Keep track of the best chromsome value at each generation
    [xb,yb]=realvalued_decode_chromosome(pop(Cindex,:));
    xS=xb;  yS=yb;

    % visualise problem id visflag has been set

    if visflag ==1
        figure(2); clf
        [Zmin Xmin Ymin]=plt_surf(8,SN);
        view(0,90)
        [xinit0,yinit0]=realvalued_decode_chromosome(pop_init);
        zinit0=realvalued_calc_binary_fitness(pop,SN);
        hndl=plot3(xinit0,yinit0,zinit0,'g.');

        title('Gen=0')
        pause(1)
    end
        
      %%  
    for gen = 1:gen_max    

        % create new population by applying selection and genetic operators

        [par1, par2] = select_parents(pop, pop_score, mating_pairs);
        [offspring_XVR] = realvalued_crossover_parents(par1,par2);
        [offspring_MUT] = realvalued_calc_mutation(offspring_XVR, mut_rate);

        % add validity check here if needed

        %retain best offspring to be next generation

        pop_score=realvalued_calc_binary_fitness(offspring_MUT,SN);

        [order_score, order_index]=sort(pop_score, 'ascend');

        pop=offspring_MUT(order_index(1:pop_size),:);
        pop_score=order_score(1:pop_size);

        scoreS = [scoreS; order_score(1)];

        [xb,yb]=realvalued_decode_chromosome(pop(1,:));
        xS=[xS ;xb];  yS=[yS; yb];

        if visflag ==1    
            [xinit,yinit]=realvalued_decode_chromosome(pop);
            zinit=realvalued_calc_binary_fitness(pop_init,SN);
            delete(hndl);
            hndl=plot3(xinit,yinit,zinit,'g.');
            title(sprintf('Gen =%d',gen))
            pause(1)
        end

    end
        


    [zGAmin, idmin]=min(scoreS);

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
    % saveas(gcf, ['Q5analysis/Surface_mut_' num2str(uint8(mut_rate*10)) '.png'])
    saveas(gcf, ['Q6analysis/Surface_mut_' num2str(gen_max_val) '.png'])
    %%
    figure(3); clf;
    g=1:1:length(scoreS);
    plot(g,scoreS,'o'); hold on
    plot(g,scoreS,'r');
    plot([g(1) g(end)],[Zmin Zmin],'k:');
    set(gca,'Xlim',[g(1) g(end)]);
    xlabel('generation no');
    ylabel('Min F(x,y) at each generation')

    % saveas(gcf, ['Q5analysis/Analysis_' num2str(uint8(mut_rate*10)) '.png'])
    saveas(gcf, ['Q6analysis/Analysis_mut_' num2str(gen_max_val) '.png'])

    act_sol=[Zmin Xmin Ymin]
    ga_best=[zGAmin xGAmin yGAmin]
    ga_fin=[zGAfin xGAfin yGAfin]

end

function [pop_ITL] = realvalued_initialization_pop(pop_size)
  no_of_genes = 20;
  pop_ITL = randi(1024, pop_size, no_of_genes);
end


function [pop_score] = realvalued_calc_binary_fitness(pop, SN)
    [x,y]=realvalued_decode_chromosome(pop);
    pop_score=myOptFunc(x,y,SN);
end

function [x,y]=realvalued_decode_chromosome(pop)
    % x=(sum(pop(:, 1:10), 2)-(round(max(max(pop)))/2))/64;
    % y=(sum(pop(:, 11:20), 2)-(round(max(max(pop)))/2))/64;
    x=(sum(pop(:, 1:10), 2)-5*1024)/256;
    y=(sum(pop(:, 11:20), 2)-5*1024)/256;
end

function [offspring_XVR] = realvalued_crossover_parents(par1,par2);
    r = rand();
    offspring1 = r*par1 + (1-r)*par2;
    offspring2 = r*par2 + (1-r)*par2;
    offspring_XVR = [offspring1; offspring2];
end

function [pop_MUT] = realvalued_calc_mutation(pop, mut_rate)
    pop_MUT = pop;
    r = randn()/10;
    rads = rand(size(pop_MUT));
    hits = rads<mut_rate;
    % pop_MUT(hits) = char('0'+('1'-pop_MUT(hits)));
    pop_MUT(hits) = pop_MUT(hits) + r;
end