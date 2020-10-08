function [Zmin Xmin Ymin]=plt_surf(range,SN)

if nargin <1
    range=2*pi;
end

if nargin <2
    params=[];
end

        % initialize
        xR = linspace( -range,  range, 1000);
        xR=xR';
      
        yR = linspace( -range,  range, 1000);
        yR=yR';
        
        Z = zeros(length(xR), length(yR));
        XG=Z;
        YG=Z;

        % simply loop through the function (most functions expect
        % [N x 2] vectors as input, so meshgrid does not work)
        for ii = 1:length(xR)
            for jj = 1:length(yR)
                Z(ii, jj) = myOptFunc(xR(ii), yR(jj),SN);
                XG(ii, jj)=xR(ii);
                YG(ii, jj)=yR(jj);
            end
        end

          
        [Zmin b]= min(Z(:));
        Xmin=XG(b);
        Ymin=YG(b);
        
        % draw surface
        clf; hold on
        surf(XG, YG, Z, 'Linestyle', 'none')

        % draw minima
%       
    plot3(Xmin, Ymin, Zmin,'r.', 'MarkerSize', 20);
%         end

        % tiles, labels, legend
        xlabel('x'), ylabel('y'), zlabel('F(x, y)')
%         if (size(solution,1) > 1)
%             legend([func2str(fun), '-function'], 'Global Minima')
%         else
%             legend([func2str(fun), '-function'], 'Global Minimum')
%         end

        % finalize
        view(-40, 30)
        grid on
        set(gcf, 'renderer', 'openGl');

    %

end
