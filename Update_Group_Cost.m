
function Structure=Update_Group_Cost(Structure, n)
    % When n = 0 the function compute Group Cost for all groups
    % When m ~= 0 the function compute Group Cost for the nth group
    nGroup=numel(Structure);    
                
        if n==0  
            
            for k=1:nGroup
                if numel(Structure(k).Group)>0
                    if ~isempty(Structure(k).PrevGroupCost)
                        Structure(k).PrevGroupCost=Structure(k).CurrentGroupCost;
                        Structure(k).CurrentGroupCost=mean([Structure(k).Group.Cost]);
                        if(Structure(k).CurrentGroupCost<Structure(k).BestGroupCost)
                            Structure(k).BestGroupCost=Structure(k).CurrentGroupCost;
                        end 
                    else  
                        tmpCost = [Structure(k).Group.Cost];
                        Structure(k).CurrentGroupCost=mean(tmpCost);
                        Structure(k).PrevGroupCost=Structure(k).CurrentGroupCost;
                        Structure(k).BestGroupCost=Structure(k).CurrentGroupCost;
                    end                                
                end
            end
            
        else
            Structure(n).PrevGroupCost=Structure(n).CurrentGroupCost;
            tmpCost = [Structure(n).Group.Cost];
            Structure(n).CurrentGroupCost=mean(tmpCost);
            if(Structure(n).CurrentGroupCost<Structure(n).BestGroupCost)
                  Structure(n).BestGroupCost=Structure(n).CurrentGroupCost;
            end 
        end
    
end