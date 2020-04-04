function  meanCost = DetermineMeanCost( Structure )
    
    Costs=[];
    for i=1:numel(Structure)
       Costs =[Costs [Structure(i).Group.Cost]];
    end
    meanCost=mean(Costs);
    
end

