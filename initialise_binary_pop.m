% Return random intialised population matrix [m-individuals x n-genes] and
% binary strings. (i.e  a character array)


function [pop_ITL] = initialise_binary_pop(pop_size)

    %no of genes is based on problem - see encoding and decoding functions
    %for details
    no_of_genes=20;
    pop_ITL = char('0'+randi([0,1], pop_size, no_of_genes));
end