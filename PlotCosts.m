
function PlotCosts(BestCosts)
    
    figure(1);
    

    plot(BestCosts,'b.');
    hold on;
%     for i=1:numel(Structure)
%        pop_costs=[Structure(i).Group.Cost]; 
%        plot(pop_costs(1,:),pop_costs(2,:),'r.');
%     end
    xlabel('Generation');
    ylabel('Fitness');
    
    grid on;
    
    hold off;

end