

function [mums dads] = select_parents(pop, pop_eval, sel_no)

% generate the chromosome pairs for crossover using roulette wheel
% selection
% can be selected more more than once, but parents much be different in
% each pair

    mums = []; dads=[];
    
    offset = min(pop_eval);
    wheel = cumsum(pop_eval-offset);
        
    for i=1:1:sel_no    
        spin = rand()*max(wheel);
        win_idx_dad = find(wheel>=spin, 1);
        new_dad = pop(win_idx_dad, :);
        
        spin = rand()*max(wheel);
        win_idx_mam = find(wheel>=spin, 1);
        
        %% reduce the chance of the same chromosome being picked twice.
        if win_idx_mam==win_idx_dad
            spin = rand()*max(wheel);
            win_idx_mam = find(wheel>=spin, 1);
        end
        
        if win_idx_mam==win_idx_dad
            spin = rand()*max(wheel);
            win_idx_mam = find(wheel>=spin, 1);
        end
              
        
        new_mum = pop(win_idx_mam, :);
        
        mums = [mums; new_mum];
        dads = [dads; new_dad];
    end
end
