
% Calculate the population score
% Returns score vector of [m-individuals x 1]
function [pop_score] = calc_binary_fitness(pop, SN)
 
%% computes the fitness of the individual as the value of the function
%% therefore in this case the smaller the value the fitter the individual.
%% hence we want to minimse the fiteness value to get the best solution
%% (note this is the opposite way round to the nornal way we think about fitness in a GA
%% but it is more convenient and logical to use for this problem --as the goal is to find the minimum point.

    [x,y]=decode_binary_chromosome(pop);
    pop_score=myOptFunc(x,y,SN);
   
end