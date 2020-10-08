function z = myOptFunc(x,y,SN)
% 2D-multimodal test function for GA optimisation
%
%   Usage: z = myOptFunc(x,ym SN)
%   where x and y are scalar values and SN is your student number.
%   
   SNR=floor(SN/10^4)*10^4;
   SN=SN-SNR;
   p1=(SN-floor(SN/10^2)*10^2-50)/10;
   p2=(floor(SN/10^2)-50)/10;
   

   z = sin(x).*exp((1-cos(y)).^2) + cos(y).*exp((1-sin(x)).^2) + (x-y).^2;
   z=z + p1*x +p2*y+200;
end
