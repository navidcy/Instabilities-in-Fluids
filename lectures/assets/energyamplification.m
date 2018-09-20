clear all;

% isnormal = 0;


for isnormal = [0, 1]

if isnormal
    A = [0 1;
         1 0];
 THETA = [-pi/3, -pi/4, pi/4];
 filenamesav = 'energyamplifnormal.png';
else
    A = [1 10;
         0 -1];
 THETA = [-atan(1/5), 0, pi/3];
 filenamesav = 'energyamplifnonnormal.png';
end
 
 figure(1);clf;
 
 T = linspace(0, 3, 101);
 dt = T(2)-T(1);
 
 
 for ith=1:length(THETA)
     theta = THETA(ith);
 
 x0 = [cos(theta);
           sin(theta)];

     xt = x0;

     E = 0*T;
     EA = expm(A*dt);


     for it=1:length(T)
         E(it) = xt.'*xt;
         xt = EA*xt;
     end

     figure(1)
     pl(ith) = semilogy(T, E, 'linewidth', 2);
     set(gca, 'fontsize', 18, 'TickLabelInterpreter', 'latex', 'TickLength',[.025 .025])
     ylabel('energy', 'fontsize', 26, 'Interpreter','latex')
     xlabel('time', 'fontsize', 26, 'Interpreter','latex')
     hold on;
 end
 
if isnormal
    h = legend([pl(1), pl(2), pl(3)], '$-\pi/3$', '$-\pi/4$', '$\pi/4$');
else
    h = legend([pl(1), pl(2), pl(3)], '$-\tan^{-1}(1/5)$', '$0$', '$\pi/3$');
end
set(h, 'fontsize', 20, 'interpreter','latex', 'location', 'southwest')
title(h, '$\theta$', 'fontsize', 20, 'interpreter','latex')
set(gcf,'Renderer','painters','Color','w');
print(gcf, '-dpng', '-r200', filenamesav); 

end