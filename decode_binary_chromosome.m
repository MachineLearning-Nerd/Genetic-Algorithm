
function [x,y]=decode_chromosome(pop)

    %convert chromosome genes back to real world values (phenotype)

    xenc=bin2dec(pop(:,1:10)); % integer in the range 0 to 1023
    yenc=bin2dec(pop(:,11:20)); % integer in the range 0 to 1023 
    x=(xenc-512)/64;
    y=(yenc-512)/64;
    
end
