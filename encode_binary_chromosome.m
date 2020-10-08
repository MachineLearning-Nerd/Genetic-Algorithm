
function [pop]=encode_chromosome(x,y)

   % converts real world values (phenotype) into chromsome representation
   %(genotype) - not required for assignment, but included here for 
   % completeness

   % x in the range -10 to 10
   % y in the range -10 to 10
   % require accuray to 1 decimal place so if we work with -100 to 100 for
   % xint and yint and then define x as xint/10 we can achieve this.
   % To convert this to a binary number we add 100 so the range now goes
   % from 0 to 200 and we can encode this as an 8 bit binary number (2^8 =
   % 256).
   
   s='needs updated'
   
   xbin=  dec2bin(floor(x*64)+512);
   ybin=  dec2bin(floor(y*64)+512);  
   pop= [xbin ybin]; %concatenate to get final chromosome.
   
end
   
