
function DetermineBest(Structure,G)
    global SM_Settings;
    if G==0
        nGroup=numel(Structure);    

        for i=1:nGroup
            
            for j=1:numel(Structure(i).Group)
                if Structure(i).Group(j).Cost<SM_Settings.BestIndividual.Cost
                    SM_Settings.BestIndividual.Cost=Structure(i).Group(j).Cost;
                    SM_Settings.BestIndividual.Decision=Structure(i).Group(j).Decision;
                end
            end
        end
        
    else

        for j=1:numel(Structure.Group)
            if Structure.Group(j).Cost<SM_Settings.BestIndividual.Cost
                    SM_Settings.BestIndividual.Cost=Structure.Group(j).Cost;
                    SM_Settings.BestIndividual.Decision=Structure.Group(j).Decision;
            end        
        end
        
    end   % IF G=0 

end