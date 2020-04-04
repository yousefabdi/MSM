
function Structure=Movement(Structure, Func, it)
    
    global ProblemSettings
    global SM_Settings 
    CostFunction=ProblemSettings.CostFunction;
    VarSize=ProblemSettings.VarSize;
    VarMin=ProblemSettings.VarMin;
    nVar=ProblemSettings.nVar;
    VarMax=ProblemSettings.VarMax;  
    W=SM_Settings.W; 
    MaxIt=SM_Settings.MaxIt; 
    
    nGroup=numel(Structure);        
        
    for i=1:nGroup
                
        % Get the Group Style Vector
        Style=Structure(i).Style;

        % Compute Probability Vector for i'th Group Style Vector
        P=exp(-Style/sum(Style));
        P=1-P;
        P=P/sum(P);
        % Select one of the Groups based on the Probability Vector
        % and Roulette Wheel Selection Method
        Selected_Style=RouletteWheelSelection(P);
        
        switch Selected_Style                

            case 1 %PSO
                
                for j=1:numel(Structure(i).Group)
                                       
%                     SM_Settings.CC=2.5-(2)*(it/MaxIt);
%                     CC=SM_Settings.CC; 
%                     CC2=2.5-2*(it/MaxIt);
                    
                    C=[Structure(i).Group.Cost];                    
                    [~,Gindex]=min(C);
                    
                     Structure(i).Group(j).Velocity = (1/(2*(log10(2)/log10(exp(1)))))*Structure(i).Group(j).Velocity ...
                     +(0.5+log10(2)/log10(exp(1)))*rand(VarSize).*(Structure(i).Group(j).BestP-Structure(i).Group(j).Decision) ...
                     +(0.5+log10(2)/log10(exp(1)))*rand(VarSize).*(Structure(i).Group(Gindex).Decision-Structure(i).Group(j).Decision);
        
                    % Apply Velocity Limits
                    if Func~=7
                        Structure(i).Group(j).Velocity = max(Structure(i).Group(j).Velocity,VarMin);
                        Structure(i).Group(j).Velocity = min(Structure(i).Group(j).Velocity,VarMax);
                    end

                    % Update Position
                    Structure(i).Group(j).Decision = Structure(i).Group(j).Decision + Structure(i).Group(j).Velocity;

                    % Velocity Mirror Effect
                    IsOutside=( Structure(i).Group(j).Decision<VarMin |  Structure(i).Group(j).Decision>VarMax);
                    Structure(i).Group(j).Velocity(IsOutside)=-Structure(i).Group(j).Velocity(IsOutside);

                    % Apply Position Limits
                    if Func~=7
                        Structure(i).Group(j).Decision = max(Structure(i).Group(j).Decision,VarMin);
                        Structure(i).Group(j).Decision = min(Structure(i).Group(j).Decision,VarMax);
                    end
                    
                    % Evaluation
                    Structure(i).Group(j).Cost = CostFunction(Structure(i).Group(j).Decision);
                    
                    if Structure(i).Group(j).Cost<Structure(i).Group(j).BestC

                        Structure(i).Group(j).BestP=Structure(i).Group(j).Decision;
                        Structure(i).Group(j).BestC=Structure(i).Group(j).Cost;

                    end
                    
                end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            case 2  %DE                   
              
                for j=1:numel(Structure(i).Group)
%                                         
                    r=randsample(numel(Structure(i).Group),3,'false');    
                    
    %                     U=Structure(i).Group(r(1)).Decision+rand*(...
    %                         Structure(i).Group(r(2)).Decision-Structure(i).Group(r(3)).Decision);   
                    U=Structure(i).Group(r(1)).Decision+0.9*(...
                         Structure(i).Group(r(2)).Decision-Structure(i).Group(r(3)).Decision);                    
                    tt=fix(rand*nVar)+1;
                    sol.Decision=zeros(1,nVar);
                    
                    j0=randi([1 nVar]);
                    for k=1:nVar
                        if k==j0 || rand<=0.9
                            sol.Decision(k)=U(k);
                        else
                            sol.Decision(k)=Structure(i).Group(j).Decision(k);
                        end
                    end
                    
                    if Func~=7
                        sol.Decision = max(sol.Decision,VarMin);
                        sol.Decision = min(sol.Decision,VarMax);
                    end
                    
                    sol.Cost=CostFunction(sol.Decision);

                    x=sol.Cost;
                    y=Structure(i).Group(j).Cost;                  
                    
                    if (x<y)  
                        Structure(i).Group(j).Decision=sol.Decision;
                        Structure(i).Group(j).Cost=sol.Cost;
                       
                        Structure(i).Group(j).BestP=Structure(i).Group(j).Decision;
                        Structure(i).Group(j).BestC=Structure(i).Group(j).Cost;
                    end  
%                                        
                end                
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%           
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            case 10 %WOA
                 [~,minIndex]=min([Structure(i).Group.Cost]);
                 Leader_score=SM_Settings.BestIndividual.Cost; % Update alpha
                 Leader_pos=SM_Settings.BestIndividual.Decision;
                 %Leader_score=Structure(i).Group(minIndex).Cost; % Update alpha
                 %Leader_pos=Structure(i).Group(minIndex).Decision;
                 a=2-it*((2)/MaxIt);
                 a2=-1+it*((-1)/MaxIt);  
                 for j=1:numel(Structure(i).Group)
                    r1=rand(); % r1 is a random number in [0,1]
                    r2=rand(); % r2 is a random number in [0,1]

                    A=2*a*r1-a;  % Eq. (2.3) in the paper
                    C=2*r2;      % Eq. (2.4) in the paper
                    b=1;               %  parameters in Eq. (2.5)
                    l=(a2-1)*rand+1;   %  parameters in Eq. (2.5)
                    
                    p = rand();        % p in Eq. (2.6) 
                    for k=1:size(Structure(i).Group(j).Decision,2)  
                        if p<0.5   
                            if abs(A)>=1
                                rand_leader_index = floor(numel(Structure(i).Group)*rand()+1);
                                X_rand = Structure(i).Group(rand_leader_index).Decision;
                                D_X_rand=abs(C*X_rand(k)-Structure(i).Group(j).Decision(k)); % Eq. (2.7)                                
                                Structure(i).Group(j).Decision(k)=X_rand(k)-A*D_X_rand;      % Eq. (2.8)
                                
                            elseif abs(A)<1
                                D_Leader=abs(C*Leader_pos(k)-Structure(i).Group(j).Decision(k));
                                Structure(i).Group(j).Decision(k)=Leader_pos(k)-A*D_Leader;
                            end

                        elseif p>=0.5
                            distance2Leader=abs(Leader_pos(k)-Structure(i).Group(j).Decision(k));
                            % Eq. (2.5)
                            Structure(i).Group(j).Decision(k)=distance2Leader*exp(b.*l).*cos(l.*2*pi)+Leader_pos(k);
                        end
                    end
                    if Func~=7
                        Structure(i).Group(j).Decision = max(Structure(i).Group(j).Decision,VarMin);
                        Structure(i).Group(j).Decision = min(Structure(i).Group(j).Decision,VarMax);
                    end

                    % Evaluation
                    Structure(i).Group(j).Cost = CostFunction(Structure(i).Group(j).Decision);

                 end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
            case 20  %TLBO
                Mean = 0;
                for k=1:numel(Structure(i).Group)
                    Mean = Mean + Structure(i).Group(k).Decision;
                end
                Mean = Mean/numel(Structure(i).Group);
                empty_individual=Structure(i).Group(1);                
                [~,minIndex]=min([Structure(i).Group.Cost]);
                Teacher = SM_Settings.BestIndividual;
                %Teacher = Structure(i).Group(minIndex);
                %Teacher Phase
                for j=1:numel(Structure(i).Group)                    
                    newsol = empty_individual;
                    TF = randi([1 2]);
                    newsol.Decision = Structure(i).Group(j).Decision+ rand(VarSize).*(Teacher.Decision - TF*Mean);
                    % Clipping
                    if Func~=7
                        newsol.Decision = max(newsol.Decision, VarMin);
                        newsol.Decision = min(newsol.Decision, VarMax);
                    end
                    newsol.Cost = CostFunction(newsol.Decision);
                    if newsol.Cost<Structure(i).Group(j).Cost
                        Structure(i).Group(j) = newsol;
                    end                    
                end
                %Learning Phase
                for j=1:numel(Structure(i).Group)
                    A = 1:numel(Structure(i).Group);
                    A(j)=[];
                    k = A(randi(numel(Structure(i).Group)-1));
                    Step = Structure(i).Group(j).Decision - Structure(i).Group(k).Decision;
                    if Structure(i).Group(k).Cost < Structure(i).Group(j).Cost
                        Step = -Step;
                    end
                    newsol = empty_individual;
                    newsol.Decision = Structure(i).Group(j).Decision + rand(VarSize).*Step;
                    % Clipping
                    if Func~=7
                        newsol.Decision = max(newsol.Decision, VarMin);
                        newsol.Decision = min(newsol.Decision, VarMax);
                    end
                    newsol.Cost = CostFunction(newsol.Decision);
                    if newsol.Cost<Structure(i).Group(j).Cost
                        Structure(i).Group(j) = newsol;
                    end  
                end
                
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end        
                   
        DetermineBest(Structure(i), 1);
                
        % Update Group Costs for i'th Group
        Structure=Update_Group_Cost(Structure, i);  
        
        % Update Style Vector of the Group
        Structure(i)=Update_Style(Structure(i), Selected_Style);
    end
   
    
end  %End of function

