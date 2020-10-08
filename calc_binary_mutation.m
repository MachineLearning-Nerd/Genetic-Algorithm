
% Mutate the population with a probability specified between 0,1
% Returns mutated population matrix (same size as input)
function [pop_MUT] = calc_mutation(pop, mut_rate)
    pop_MUT = pop;
    rads = rand(size(pop_MUT));
    hits = rads<mut_rate;
    pop_MUT(hits) = char('0'+('1'-pop_MUT(hits)));
end