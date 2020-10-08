

function [offspring_XVR] = crossover_parents(par1,par2);
    offspring_XVR = [];
    xvr_n = size(par1,2);
    N_couples = size(par1,1);
    for i=1:1:N_couples
        xvr = randi(xvr_n,2,1);
        ia = min(xvr);
        ib = max(xvr);
        kid1 = par1(i,:);
        kid2 = par2(i,:);
        kid1(ia:ib) = par2(i,ia:ib);
        if ia>1
           kid2(1:ia-1)=par1(i,1:(ia-1));
        end
        if ib< size(kid2,2);
            kid2(ib+1:end)=par1(i,ib+1:end);
        end
        offspring_XVR = [offspring_XVR; kid1 ; kid2];
    end
end
